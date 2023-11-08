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

#define CONST_FP(num) ConstantFP::get(num, module) // 得到常数值的表示,方便后面多次用到

int main(){
    auto module = new Module("assign_generator");
    auto builder = new IRBuilder(nullptr, module);
    Type *Int32Type = Type::get_int32_type(module);

    std::vector<Type *> Ints(0);
   
    auto Main = Function::create( FunctionType::get(Int32Type,Ints),"main",module);

    auto bb = BasicBlock::create(module,"entry",Main);
    builder->set_insert_point(bb);

    auto ArrayAlloca = builder->create_alloca(ArrayType::get(Int32Type,10));
    auto retAlloca = builder->create_alloca(Int32Type);

    auto Arr0 = builder->create_gep(ArrayAlloca,{CONST_INT(0),CONST_INT(0)});
    builder->create_store(CONST_INT(10),Arr0);
    auto Arr1 = builder->create_gep(ArrayAlloca,{CONST_INT(0),CONST_INT(1)});
    auto Load_value0 = builder->create_load(Arr0);
    auto mul = builder->create_imul(Load_value0,CONST_INT(2));
    builder->create_store(mul,Arr1);

    auto Load_value1 = builder->create_load(Arr1);
    builder->create_store(Load_value1,retAlloca);

    auto retLoad = builder->create_load(retAlloca);
    builder->create_ret(retLoad);

    std::cout << module->print();
    delete module;
    return 0;
}
