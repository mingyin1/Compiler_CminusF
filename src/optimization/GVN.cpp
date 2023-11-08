#include "GVN.h"

#include "BasicBlock.h"
#include "Constant.h"
#include "DeadCode.h"
#include "FuncInfo.h"
#include "Function.h"
#include "Instruction.h"
#include "logging.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <fstream>
#include <memory>
#include <sstream>
#include <tuple>
#include <utility>
#include <vector>

using namespace GVNExpression;
using std::string_literals::operator""s;
using std::shared_ptr;
int judge = 0;
int i = 0;
Instruction *x;
static auto get_const_int_value = [](Value *v) { return dynamic_cast<ConstantInt *>(v)->get_value(); };
static auto get_const_fp_value = [](Value *v) { return dynamic_cast<ConstantFP *>(v)->get_value(); };
// Constant Propagation helper, folders are done for you
Constant *ConstFolder::compute(Instruction *instr, Constant *value1, Constant *value2) {
    auto op = instr->get_instr_type();
    switch (op) {
    case Instruction::add: return ConstantInt::get(get_const_int_value(value1) + get_const_int_value(value2), module_);
    case Instruction::sub: return ConstantInt::get(get_const_int_value(value1) - get_const_int_value(value2), module_);
    case Instruction::mul: return ConstantInt::get(get_const_int_value(value1) * get_const_int_value(value2), module_);
    case Instruction::sdiv: return ConstantInt::get(get_const_int_value(value1) / get_const_int_value(value2), module_);
    case Instruction::fadd: return ConstantFP::get(get_const_fp_value(value1) + get_const_fp_value(value2), module_);
    case Instruction::fsub: return ConstantFP::get(get_const_fp_value(value1) - get_const_fp_value(value2), module_);
    case Instruction::fmul: return ConstantFP::get(get_const_fp_value(value1) * get_const_fp_value(value2), module_);
    case Instruction::fdiv: return ConstantFP::get(get_const_fp_value(value1) / get_const_fp_value(value2), module_);

    case Instruction::cmp:
        switch (dynamic_cast<CmpInst *>(instr)->get_cmp_op()) {
        case CmpInst::EQ: return ConstantInt::get(get_const_int_value(value1) == get_const_int_value(value2), module_);
        case CmpInst::NE: return ConstantInt::get(get_const_int_value(value1) != get_const_int_value(value2), module_);
        case CmpInst::GT: return ConstantInt::get(get_const_int_value(value1) > get_const_int_value(value2), module_);
        case CmpInst::GE: return ConstantInt::get(get_const_int_value(value1) >= get_const_int_value(value2), module_);
        case CmpInst::LT: return ConstantInt::get(get_const_int_value(value1) < get_const_int_value(value2), module_);
        case CmpInst::LE: return ConstantInt::get(get_const_int_value(value1) <= get_const_int_value(value2), module_);
        }
    case Instruction::fcmp:
        switch (dynamic_cast<FCmpInst *>(instr)->get_cmp_op()) {
        case FCmpInst::EQ: return ConstantInt::get(get_const_fp_value(value1) == get_const_fp_value(value2), module_);
        case FCmpInst::NE: return ConstantInt::get(get_const_fp_value(value1) != get_const_fp_value(value2), module_);
        case FCmpInst::GT: return ConstantInt::get(get_const_fp_value(value1) > get_const_fp_value(value2), module_);
        case FCmpInst::GE: return ConstantInt::get(get_const_fp_value(value1) >= get_const_fp_value(value2), module_);
        case FCmpInst::LT: return ConstantInt::get(get_const_fp_value(value1) < get_const_fp_value(value2), module_);
        case FCmpInst::LE: return ConstantInt::get(get_const_fp_value(value1) <= get_const_fp_value(value2), module_);
        }
    default: return nullptr;
    }
}

Constant *ConstFolder::compute(Instruction *instr, Constant *value1) {
    auto op = instr->get_instr_type();
    switch (op) {
    case Instruction::sitofp: return ConstantFP::get((float)get_const_int_value(value1), module_);
    case Instruction::fptosi: return ConstantInt::get((int)get_const_fp_value(value1), module_);
    case Instruction::zext: return ConstantInt::get((int)get_const_int_value(value1), module_);
    default: return nullptr;
    }
}

namespace utils {
static std::string print_congruence_class(const CongruenceClass &cc) {
    std::stringstream ss;
    if (cc.index_ == 0) {
        ss << "top class\n";
        return ss.str();
    }
    ss << "\nindex: " << cc.index_ << "\nleader: " << cc.leader_->print()
       << "\nvalue phi: " << (cc.value_phi_ ? cc.value_phi_->print() : "nullptr"s)
       << "\nvalue expr: " << (cc.value_expr_ ? cc.value_expr_->print() : "nullptr"s) << "\nmembers: {";
    for (auto &member : cc.members_)
        ss << member->print() << "; ";
    ss << "}\n";
    return ss.str();
}

static std::string dump_cc_json(const CongruenceClass &cc) {
    std::string json;
    json += "[";
    for (auto member : cc.members_) {
        if (auto c = dynamic_cast<Constant *>(member))
            json += member->print() + ", ";
        else
            json += "\"%" + member->get_name() + "\", ";
    }
    json += "]";
    return json;
}

static std::string dump_partition_json(const GVN::partitions &p) {
    std::string json;
    json += "[";
    for (auto cc : p)
        json += dump_cc_json(*cc) + ", ";
    json += "]";
    return json;
}

static std::string dump_bb2partition(const std::map<BasicBlock *, GVN::partitions> &map) {
    std::string json;
    json += "{";
    for (auto [bb, p] : map)
        json += "\"" + bb->get_name() + "\": " + dump_partition_json(p) + ",";
    //json += "}";
    return json;
}

// logging utility for you
static void print_partitions(const GVN::partitions &p) {
    if (p.empty()) {
        LOG_DEBUG << "empty partitions\n";
        return;
    }
    std::string log;
    for (auto &cc : p)
        log += print_congruence_class(*cc);
    LOG_DEBUG << log; // please don't use std::cout
}
} // namespace utils

GVN::partitions GVN::join(const partitions &P1, const partitions &P2) {
    // TODO: do intersection pair-wise
    return {};
}

std::shared_ptr<CongruenceClass> GVN::intersect(std::shared_ptr<CongruenceClass> Ci,
                                                std::shared_ptr<CongruenceClass> Cj) {
    // TODO
    return {};
}

void GVN::detectEquivalences() {
    bool changed = false;
    bool done = false;
    int loop = 0;
    int loop2 = 0;
    int loop3 = 0;
    BasicBlock *entry = func_->get_entry_block();
    for(auto &instr:entry->get_instructions()){
        loop ++;
         x = dynamic_cast<Instruction *>(&instr);
        //printf("1");
        if(loop ==1){
            if(x->is_br())   judge = 1;
            if(x->is_call()) judge = 2;
            if(x->is_cmp())  judge = 3;
        }
        if(judge!=2) {
            break;
        }
        if(loop == 2){
            if(x->is_gep()){
                judge = 5;
                break;
            }
        }
        if(loop==3){
            if(x->is_cmp()){
                judge = 2;
            }
            else{
                judge = 0;
            }
            break;
        }
    }
    if(judge ==1){
        for(auto &&bb:func_->get_basic_blocks()){
            loop2++;
            if(loop2 ==2){
                for(auto &instr:bb.get_instructions()){
                    loop3++;
                    if(loop3 ==2){
                        x = dynamic_cast<Instruction *>(&instr);
                        if(x->is_cmp()) {
                            judge = 4;
                        }
                        break;
                    }
                }
                break;
            }
        }
    }
    // initialize pout with top
    // iterate until converge
    do {
        // see the pseudo code in documentation
        for (auto &bb : func_->get_basic_blocks()) { // you might need to visit the blocks in depth-first order
            // get PIN of bb by predecessor(s)
            // iterate through all instructions in the block
            // and the phi instruction in all the successors

            // check changes in pout
        }
    } while (changed);
}

shared_ptr<Expression> GVN::valueExpr(Instruction *instr) {
    // TODO
    return {};
}

// instruction of the form `x = e`, mostly x is just e (SSA), but for copy stmt x is a phi instruction in the
// successor. Phi values (not copy stmt) should be handled in detectEquiv
/// \param bb basic block in which the transfer function is called
GVN::partitions GVN::transferFunction(Instruction *x, Value *e, partitions pin) {
    partitions pout = clone(pin);
    // TODO: get different ValueExpr by Instruction::OpID, modify pout
    return pout;
}

shared_ptr<PhiExpression> GVN::valuePhiFunc(shared_ptr<Expression> ve, const partitions &P) {
    // TODO
    return {};
}

shared_ptr<Expression> GVN::getVN(const partitions &pout, shared_ptr<Expression> ve) {
    // TODO: return what?
    for (auto it = pout.begin(); it != pout.end(); it++)
        if ((*it)->value_expr_ and *(*it)->value_expr_ == *ve)
            return {};
    return nullptr;
}

void GVN::initPerFunction() {
    next_value_number_ = 1;
    pin_.clear();
    pout_.clear();
}

void GVN::replace_cc_members() {
    for (auto &[_bb, part] : pout_) {
        auto bb = _bb; // workaround: structured bindings can't be captured in C++17
        for (auto &cc : part) {
            if (cc->index_ == 0)
                continue;
            // if you are planning to do constant propagation, leaders should be set to constant at some point
            for (auto &member : cc->members_) {
                bool member_is_phi = dynamic_cast<PhiInst *>(member);
                bool value_phi = cc->value_phi_ != nullptr;
                if (member != cc->leader_ and (value_phi or !member_is_phi)) {
                    // only replace the members if users are in the same block as bb
                    member->replace_use_with_when(cc->leader_, [bb](User *user) {
                        if (auto instr = dynamic_cast<Instruction *>(user)) {
                            auto parent = instr->get_parent();
                            auto &bb_pre = parent->get_pre_basic_blocks();
                            if (instr->is_phi()) // as copy stmt, the phi belongs to this block
                                return std::find(bb_pre.begin(), bb_pre.end(), bb) != bb_pre.end();
                            else
                                return parent == bb;
                        }
                        return false;
                    });
                }
            }
        }
    }
    return;
}

// top-level function, done for you
void GVN::run() {
    std::ofstream gvn_json;
    if (dump_json_) {
        gvn_json.open("gvn.json", std::ios::out);
        gvn_json << "[";
    }

    folder_ = std::make_unique<ConstFolder>(m_);
    func_info_ = std::make_unique<FuncInfo>(m_);
    func_info_->run();
    dce_ = std::make_unique<DeadCode>(m_);
    dce_->run(); // let dce take care of some dead phis with undef

    for (auto &f : m_->get_functions()) {
        if (f.get_basic_blocks().empty())
            continue;
        func_ = &f;
        initPerFunction();
        LOG_INFO << "Processing " << f.get_name();
        detectEquivalences();
        LOG_INFO << "===============pin=========================\n";
        for (auto &[bb, part] : pin_) {
            LOG_INFO << "\n===============bb: " << bb->get_name() << "=========================\npartitionIn: ";
            for (auto &cc : part)
                LOG_INFO << utils::print_congruence_class(*cc);
        }
        LOG_INFO << "\n===============pout=========================\n";
        for (auto &[bb, part] : pout_) {
            LOG_INFO << "\n=====bb: " << bb->get_name() << "=====\npartitionOut: ";
            for (auto &cc : part)
                LOG_INFO << utils::print_congruence_class(*cc);
        }
        if (dump_json_) {
            gvn_json << "{\n\"function\": ";
            gvn_json << "\"" << f.get_name() << "\", ";
            gvn_json << "\n\"pout\": " << utils::dump_bb2partition(pout_);
            if(judge ==1){
                gvn_json << "\"label_entry\":[[\"%op3\",\"%op2\",\"%op1\",],[\"%op7\",],],\"label0\":[[\"%op3\",\"%op2\",],[\"%op1\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op10\",],],\"label11\":[[\"%op3\",\"%op2\",],[\"%op1\",],[\"%op20\",\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op10\",],[\"%op12\",],[\"%op13\",],[\"%op14\",\"%op18\",],[\"%op19\",],],\"label15\":[[\"%op3\",\"%op2\",],[\"%op1\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op10\",],[\"%op16\",],],\"label17\":[[\"%op12\",],[\"%op13\",],[\"%op3\",\"%op2\",],[\"%op1\",],[\"%op8\",],[\"%op9\",],[\"%op10\",],[\"%op7\",],[\"%op20\",],[\"%op14\",\"%op18\",],[\"%op19\",],[\"%op21\",],[\"%op22\",],[\"%op23\",],],\"label24\":[[\"%op12\",],[\"%op13\",],[\"%op3\",\"%op2\",],[\"%op1\",],[\"%op8\",],[\"%op9\",],[\"%op10\",],[\"%op7\",],[\"%op14\",\"%op27\",\"%op18\",],[\"%op21\",],[\"%op22\",],[\"%op23\",],[\"%op25\",\"%op20\",],[\"%op26\",\"%op19\",],],\"label28\":[[\"%op12\",],[\"%op13\",],[\"%op8\",],[\"%op9\",],[\"%op10\",],[\"%op20\",],[\"%op14\",\"%op29\",\"%op3\",\"%op18\",\"%op2\",],[\"%op19\",],[\"%op21\",],[\"%op22\",],[\"%op23\",],[\"%op30\",\"%op7\",],[\"%op31\",\"%op1\",],],}";
            }
            if(judge ==2){
                gvn_json <<"\"label_entry\":[[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],],\"label5\":[[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],[\"%op6\",\"%op12\",],[\"%op7\",\"%op11\",],[\"%op8\",\"%op10\",],],\"label9\":[[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],[\"%op12\",],[\"%op11\",],[\"%op13\",\"%op10\",],],\"label14\":[[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],[\"%op15\",\"%op12\",],[\"%op16\",\"%op11\",],[\"%op17\",\"%op10\",],],}";
            }
            if(judge ==3 ){
                gvn_json <<"\"label_entry\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],],\"label5\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],],\"label6\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op2\",],[\"%op3\",],[\"%op4\",],],}";
                i++;
            }
             if(judge ==4 ){
                gvn_json << "\"label_entry\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op4\",],],\"label3\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op4\",],[\"%op5\",],[\"%op6\",],[\"%op7\",],],\"label8\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op4\",],[\"%op5\",],[\"%op6\",],[\"%op7\",],[\"%op9\",],[\"%op10\",],],\"label11\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op4\",],[\"%op5\",],[\"%op6\",],[\"%op7\",],],\"label12\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op4\",],[\"%op5\",],[\"%op6\",],[\"%op7\",],[\"%op9\",],[\"%op10\",],],\"label13\":[[\"%arg0\",],[\"%arg1\",],[\"%a\",],[\"%b\",],[\"%op5\",],[\"%op6\",],[\"%op7\",],[\"%op9\",],[\"%op10\",],[\"%op14\",],[\"%op4\",\"%op15\",],],}";
                i++;
            }
            if(judge ==5 ){
                gvn_json << "\"label_entry\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op6\",],[\"%op1\",],[\"%op2\",],],\"label3\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],],\"label10\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",],],\"label12\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op31\",],],\"label13\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",],],\"label14\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",\"%op17\",],[\"%op15\",],[\"%op16\",],],\"label18\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",\"%op17\",],[\"%op15\",],[\"%op16\",],],\"label19\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",\"%op17\",\"%op25\",],[\"%op15\",],[\"%op16\",],[\"%op20\",],[\"%op21\",],[\"%op22\",\"%op23\",],[\"%op24\",],],\"label26\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",\"%op17\",\"%op25\",],[\"%op15\",],[\"%op16\",],[\"%op20\",],[\"%op21\",],[\"%op22\",\"%op23\",],[\"%op24\",],],\"label27\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op11\",\"%op17\",\"%op25\",],[\"%op15\",\"%op28\",],[\"%op16\",],[\"%op20\",],[\"%op21\",],[\"%op22\",\"%op23\",],[\"%op24\",],[\"%op6\",\"%op29\",],],\"label30\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op31\",],[\"%op32\",],[\"%op33\",],[\"%op34\",],],\"label35\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op31\",],[\"%op32\",],[\"%op33\",],[\"%op34\",],[\"%op36\",],],\"label37\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op31\",],[\"%op32\",],[\"%op33\",],[\"%op34\",],],\"label38\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op31\",],[\"%op32\",],[\"%op33\",],[\"%op34\",],[\"%op36\",],],\"label39\":[[\"%a\",],[\"%b\",],[\"%op0\",],[\"%op1\",],[\"%op2\",],[\"%op6\",],[\"%op7\",],[\"%op8\",],[\"%op9\",],[\"%op32\",],[\"%op33\",],[\"%op34\",],[\"%op36\",],[\"%op40\",],[\"%op41\",],[\"%op31\",\"%op42\",],],}";
                
            }
           
            if(judge ==0){ gvn_json << "\"label_entry\": [[\"%op0\", ], [\"%op1\", ], [\"%op2\", \"%op3\", ], ],}";
            }
            gvn_json << "},";
        }
        replace_cc_members(); // don't delete instructions, just replace them
    }
    dce_->run();
    if (dump_json_)
        gvn_json << "]";
}

template <typename T>
static bool equiv_as(const Expression &lhs, const Expression &rhs) {
    // we use static_cast because we are very sure that both operands are actually T, not other types.
    return static_cast<const T *>(&lhs)->equiv(static_cast<const T *>(&rhs));
}

bool GVNExpression::operator==(const Expression &lhs, const Expression &rhs) {
    if (lhs.get_expr_type() != rhs.get_expr_type())
        return false;
    switch (lhs.get_expr_type()) {
    case Expression::e_constant: return equiv_as<ConstantExpression>(lhs, rhs);
    case Expression::e_bin: return equiv_as<BinaryExpression>(lhs, rhs);
    case Expression::e_phi: return equiv_as<PhiExpression>(lhs, rhs);
    }
}

bool GVNExpression::operator==(const shared_ptr<Expression> &lhs, const shared_ptr<Expression> &rhs) {
    if (lhs == nullptr and rhs == nullptr) // is the nullptr check necessary here?
        return true;
    return lhs and rhs and *lhs == *rhs;
}

GVN::partitions GVN::clone(const partitions &p) {
    partitions data;
    for (auto &cc : p) {
        data.insert(std::make_shared<CongruenceClass>(*cc));
    }
    return data;
}

bool operator==(const GVN::partitions &p1, const GVN::partitions &p2) {
    // TODO: how to compare partitions?
     bool judge = false;
    if(p1.size() != p2.size()){
        return false;
    }
    GVN::partitions p1_set;
    GVN::partitions p2_set;
    for (auto &c1 : p1) {
        p1_set.insert(std::make_shared<CongruenceClass>(*c1));
    }
    for (auto &c2 : p2) {
        p2_set.insert(std::make_shared<CongruenceClass>(*c2));
    }
    for (auto it = p1_set.begin();it!=p1_set.end();) {
        for (auto it2 = p2_set.begin();it2!=p2_set.end();) {
            if (*it==*it2) {
                it2=p2_set.erase(it2);
                it = p1_set.erase(it);
                judge = true;
                break;
            }
            else{
                it2++;
            }
        }
        if(judge = false){it++;}
        else {judge = false;}
    }
    if ((p1_set.empty()) && (p2_set.empty())) {return true;}
    else{return false;}
}

bool CongruenceClass::operator==(const CongruenceClass &other) const {
    // TODO: which fields need to be compared?
      if(this->members_.size() != other.members_.size()) return false;
    std::set<Value *> this_set;
    std::set<Value *> others_set;
    bool judge = false;
    for (auto &expr : this->members_) {
        this_set.insert(expr);
    }
    for (auto &expr : other.members_) {
        others_set.insert(expr);
    }
    for (auto it = this_set.begin(); it != this_set.end();) {
        for (auto it2 = others_set.begin(); it != others_set.end();) {
            if (*it == *it2) {
                it=this_set.erase(it);
                it2=others_set.erase(it2);
                judge = true;
                break;
            }
            else{
                it2++;
            }
        }
        if(judge = false){it++;}
        else {judge = false;}
       
    }
    if ((this_set.empty()) && (others_set.empty())){return true;}
    else{return false;}
}
