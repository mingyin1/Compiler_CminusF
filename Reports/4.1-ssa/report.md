# Lab4.1 实验报告

## 实验要求

1.阅读SSA IR材料，理解SSA 的形式以及格式的细节<br>
2.学习Mem2Reg Pass的有关知识，阅读4段代码<br>
3.注册及运行 Mem2Reg Pass，观察运行结果

## 思考题

### Mem2reg

### 1. 请简述概念：支配性、严格支配性、直接支配性、支配边界。

+ 支配性：在入口节点为 $b0$ 的流图中，当且仅当 $bi$ 位于从 $b0$ 到 $bj$ 的每条路径上时，结点 $bi$ 支配结点 $bj$。此外，对$\forall bi$，$bi$支配于自身

+ 严格支配性：在一个结点的支配集中去掉该结点自身，则集合中剩下的元素严格支配于该结点。即：若 $bi\in Dom(bj)$ 且 $bi\not=bj$,则称$bi$严格支配$bj$

+ 直接支配性：当$bi$严格支配$bj$且$bi$是距离$bj$最近的结点，则称$bi$直接支配$bj$

+ 支配边界：对于流图上的两个结点$bi$和$bj$，如果$bi$支配$bj$的某一个前驱结点，且$bi$不严格支配$bj$，则称$bj$是$bi$的支配边界。
  
  ### 2. phi节点是SSA的关键特征，请简述phi节点的概念，以及引入phi节点的理由。
  
  phi节点表现为phi函数的形式。它可以通过判断程序执行了哪一个前驱基本块，从而确定变量的定值来源
  
  引入phi节点的理由在于：

+ 帮助SSA进行代码的优化。具体来说，在SSA的过程中，各个代码块中的静态单变量形式名都不相同，当遇到分支的时候需要判断一个赋值语句所引用的变量来自于哪一条路径。

+ phi节点本身可以用来删除多余的load和store指令。
  
  ### 3.观察下面给出的cminus程序对应的 LLVM IR，与开启Mem2Reg生成的LLVM IR对比，每条load, store指令发生了变化吗？变化或者没变化的原因是什么？请分类解释。
  
  `func`函数：
  
  ```c
  int func(int x){
    if(x > 0){
        x = 0;
    }
    return x;
  }
  ```
  
  ```llvm
  define i32 @func(i32 %arg0) {
  label_entry:
  %op1 = alloca i32
  store i32 %arg0, i32* %op1
  %op2 = load i32, i32* %op1
  %op3 = icmp sgt i32 %op2, 0
  %op4 = zext i1 %op3 to i32
  %op5 = icmp ne i32 %op4, 0
  br i1 %op5, label %label6, label %label7
  label6:                                                ; preds = %label_entry
  store i32 0, i32* %op1
  br label %label7
  label7:                                                ; preds = %label_entry, %label6
  %op8 = load i32, i32* %op1
  ret i32 %op8
  }
  ```
  
  ```llvm
  define i32 @func(i32 %arg0) {
  label_entry:
  %op3 = icmp sgt i32 %arg0, 0
  %op4 = zext i1 %op3 to i32
  %op5 = icmp ne i32 %op4, 0
  br i1 %op5, label %label6, label %label7
  label6:                                                ; preds = %label_entry
  br label %label7
  label7:                                                ; preds = %label_entry, %label6
  %op9 = phi i32 [ %arg0, %label_entry ], [ 0, %label6 ]
  ret i32 %op9
  }
  ```
  
  通过比较上面`llvm`代码的区别，发现了以下变化:

+ 第一个store是将函数形参的值存入建立的新变量中，但是由于后续可以直接引用函数形参的值,所以可以省略该变量的定义和store操作。

+ 第二个store是将0的值赋给x，这个定值可以直接被后面的引用，所以可以删除。

+ 由于有不同的值到达该结点，所以需要phi函数确定具体的取值。如果定值从`%label_entry`进入了`label7`，那么取值就是`%arg0`；如果定值从`label6`进入`label7`，那么取值就是0

`main`函数：

```c
int main(void){
  int arr[10];
  int b;
  globVar = 1;
  arr[5] = 999;
  b = 2333;
  func(b);
  func(globVar);
  return 0;
}
```

```llvm
  define i32 @main() {
label_entry:
  %op0 = alloca [10 x i32]
  %op1 = alloca i32
  store i32 1, i32* @globVar
  %op2 = icmp slt i32 5, 0
  br i1 %op2, label %label3, label %label4
label3:                                                ; preds = %label_entry
  call void @neg_idx_except()
  ret i32 0
label4:                                                ; preds = %label_entry
  %op5 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 5
  store i32 999, i32* %op5
  store i32 2333, i32* %op1
  %op6 = load i32, i32* %op1
  %op7 = call i32 @func(i32 %op6)
  %op8 = load i32, i32* @globVar
  %op9 = call i32 @func(i32 %op8)
  ret i32 0
}
```

```llvm
define i32 @main() {
label_entry:
%op0 = alloca [10 x i32]
store i32 1, i32* @globVar
%op2 = icmp slt i32 5, 0
br i1 %op2, label %label3, label %label4
label3:                                                ; preds = %label_entry
call void @neg_idx_except()
ret i32 0
label4:                                                ; preds = %label_entry
%op5 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 5
store i32 999, i32* %op5
%op7 = call i32 @func(i32 2333)
%op8 = load i32, i32* @globVar
%op9 = call i32 @func(i32 %op8)
ret i32 0
}
```

通过比较上面`llvm`代码的区别，发现了以下变化:

+ 删除了一条load指令和一条store指令，删除的原因是变量b的值在整个函数执行过程中没有改变，所以可以直接存储常数2333，从而不需要load和store指令。

### 4.指出放置phi节点的代码，并解释是如何使用支配树的信息的。（需要给出代码中的成员变量或成员函数名称）

放置phi节点的代码如下：

```llvm
    %op9 = phi i32 [ %arg0, %label_entry ], [ 0, %label6 ]
```

放置支配性信息的代码如下：

```c
std::map<std::pair<BasicBlock *, Value *>, bool> bb_has_var_phi; // bb has phi for var
    for (auto var : global_live_var_name) {
        std::vector<BasicBlock *> work_list;
        work_list.assign(live_var_2blocks[var].begin(), live_var_2blocks[var].end());
        for (int i = 0; i < work_list.size(); i++) {
            auto bb = work_list[i];
            for (auto bb_dominance_frontier_bb : dominators_->get_dominance_frontier(bb)) {
                if (bb_has_var_phi.find({bb_dominance_frontier_bb, var}) == bb_has_var_phi.end()) {
                    // generate phi for bb_dominance_frontier_bb & add bb_dominance_frontier_bb to work list
                    auto phi =
                        PhiInst::create_phi(var->get_type()->get_pointer_element_type(), bb_dominance_frontier_bb);
                    phi->set_lval(var);
                    bb_dominance_frontier_bb->add_instr_begin(phi);
                    work_list.push_back(bb_dominance_frontier_bb);
                    bb_has_var_phi[{bb_dominance_frontier_bb, var}] = true;
                }
            }
        }
    }
```

该代码是通过支配树中的 `get_dominance_frontier(bb)` 函数寻找当前块的支配边界。<br>
然后再判断支配边界的结点是否存在该变量的phi函数，如果不存在则插入phi函数。
具体来说，对bb支配边界中的所有块，首先在块起始处插入相应的phi节点，并将
`bb_dominance_frontier_bb`入栈`work_list`，并使用`bb_has_var_phi`来保存相应信息。

### 5.算法是如何选择value(变量最新的值)来替换load指令的？（描述清楚对应变量与维护该变量的位置）

代码如下：

```c
    std::vector<Instruction *> wait_delete;

    // 步骤三：将 phi 指令作为 lval 的最新定值，lval 即是为局部变量 alloca 出的地址空间
    for (auto &instr1 : bb->get_instructions()) {
        auto instr = &instr1;
        if (instr->is_phi()) {
            auto l_val = static_cast<PhiInst *>(instr)->get_lval();
            var_val_stack[l_val].push_back(instr);
        }
    }

    for (auto &instr1 : bb->get_instructions()) {
        auto instr = &instr1;
        // 步骤四：用 lval 最新的定值替代对应的load指令
        if (instr->is_load()) {
            auto l_val = static_cast<LoadInst *>(instr)->get_lval();

            if (!IS_GLOBAL_VARIABLE(l_val) && !IS_GEP_INSTR(l_val)) {
                if (var_val_stack.find(l_val) != var_val_stack.end()) {
                    // 此处指令替换会维护 UD 链与 DU 链
                    instr->replace_all_use_with(var_val_stack[l_val].back());
                    wait_delete.push_back(instr);
                }
            }
        }
        // 步骤五：将 store 指令的 rval，也即被存入内存的值，作为 lval 的最新定值
        if (instr->is_store()) {
            auto l_val = static_cast<StoreInst *>(instr)->get_lval();
            auto r_val = static_cast<StoreInst *>(instr)->get_rval();

            if (!IS_GLOBAL_VARIABLE(l_val) && !IS_GEP_INSTR(l_val)) {
                var_val_stack[l_val].push_back(r_val);
                wait_delete.push_back(instr);
            }
        }
    }
```

使用phi指令维护最新值，并将其压入`var_val_stack[l_val]`栈中。对于store指令，将右值`r_val`压入`var_val_stack[l_val]`栈中。<br>
不过这种做法不能处理指针以及全局变量，所以需要加上判断语句`if (!IS_GLOBAL_VARIABLE(l_val) && !IS_GEP_INSTR(l_val))` 和`if (var_val_stack.find(l_val) != var_val_stack.end())`。<br>之后可以通过`instr->replace_all_use_with(var_val_stack[l_val].back())`进行load指令的替换

### 代码阅读总结

此次实验有什么收获

+ 学习了有关SSA的相关知识，对中间代码优化有了更深的理解

+ 提高了代码的阅读能力
  
  ### 实验反馈 （可选 不会评分）

对本次实验的建议
无