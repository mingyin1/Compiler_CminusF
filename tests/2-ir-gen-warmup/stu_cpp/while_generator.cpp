#include "BasicBlock.h"
#include "Constant.h"
#include "Function.h"
#include "IRBuilder.h"
#include "Module.h"
#include "Type.h"

#include <iostream>
#include <memory>

#ifdef DEBUG  // 用于调试信息,大家可以在编译过程中通过" -DDEBUG"来开启这一选项
#define DEBUG_OUTPUT std::cout << __LINE__ << std::endl;  // 输出行号的简单示例
#else
#define DEBUG_OUTPUT
#endif

#define CONST_INT(num) ConstantInt::get(num, module)

#define CONST_FP(num) ConstantFP::get(num, module) 

int main(){
    auto module = new Module("while_generator");
    auto builder = new IRBuilder(nullptr, module);
    Type *Int32Type = Type::get_int32_type(module);
    Type *FloatType = Type::get_float_type(module);

    auto mainFun = Function::create(FunctionType::get(Int32Type, {}),"main", module);

    auto bb = BasicBlock::create (module, "entry", mainFun);
    builder->set_insert_point(bb);
    auto retAlloca = builder->create_alloca(Int32Type);
    auto Addr = builder->create_alloca(Int32Type);
    auto iAddr = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(10), Addr);
    builder->create_store(CONST_INT(0), iAddr);
    auto checkBB = BasicBlock::create(module, "", mainFun);
    builder->create_br(checkBB);

    builder->set_insert_point(checkBB);
    auto iLoad = builder->create_load(iAddr);
    auto icmp = builder->create_icmp_lt(iLoad, CONST_INT(10));
    auto loopBB = BasicBlock::create(module, "", mainFun);
    auto retBB = BasicBlock::create(module, "", mainFun);
    auto br = builder->create_cond_br(icmp, loopBB, retBB);    

    builder->set_insert_point(loopBB);
    iLoad = builder->create_load(iAddr);
    auto iLoad1 = builder->create_iadd(iLoad, CONST_INT(1));
    builder->create_store(iLoad1, iAddr);
    auto aValue = builder->create_load(Addr);
    auto Add = builder->create_iadd(aValue, iLoad1);
    builder->create_store(Add, Addr);
    builder->create_br(checkBB);  

    builder->set_insert_point(retBB); 
    aValue = builder->create_load(Addr);
    builder->create_store(aValue, retAlloca);
    auto retLoad = builder->create_load(retAlloca);
    builder->create_ret(retLoad);

    std::cout << module->print();
    delete module;
    return 0;
}