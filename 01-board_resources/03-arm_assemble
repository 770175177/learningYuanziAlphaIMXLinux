[TOC]

# 一、ARM 汇编
## 1.1 汇编语法
### 1.1.1 GNU 汇编
``` bash
    label：instruction @ comment
    # label 即标号，表示地址位置，任何以 ':' 结尾的标识符都被识别为一个标号
    # instruction 即指令，也就是汇编指令或伪指令
    # @ 符号，表示后面的是注释，也可以使用 '/* */' 来注释。comment 就是注释内容
    # 如下，add 是标号，'MOVS R0, #0X12' 是指令，'@ 设置 R0=0X12' 是注释：
    add:
        MOVS R0, #0X12          @ 设置 R0=0X12
```
### 1.1.2 使用 .section 伪操定义一个段
``` bash
    .text                       # 表示代码段，预定义的
    .data                       # 初始化的数据段，预定义的
    .bss                        # 未初始化的数据段，预定义的
    .rodata                     # 只读数据段，预定义的
    .section .testsection       # 自定义一个 testsetcion 段
```
### 1.1.3 汇编入口点
``` bash
    .global _start              # .global 是伪操作，表示 _start 是一个全局标号
    _start:                     # 汇编程序的默认入口标号 _start
        ldr r0, =0x12 @r0=0x12
    # 也可以在链接脚本中使用 ENTRY 来指明其它的入口点
```
### 1.1.4 常见的伪操作
``` bash
    .byte                       # 定义单字节数据，比如 .byte 0x12
    .short                      # 定义双字节数据，比如 .short 0x1234。
    .long                       # 定义一个 4 字节数据，比如 .long 0x12345678。
    .equ                        # 赋值语句，格式为：.equ 变量名，表达式，
                                #   比如 .equ num, 0x12，表示 num=0x12。
    .align                      # 数据字节对齐，比如：.align 4 表示 4 字节对齐。
    .end                        # 表示源文件结束。
    .global                     # 定义一个全局符号，格式为：.global symbol，
                                #   比如：.global _start。
```
### 1.1.5 汇编函数
``` bash
    # 函数格式
    函数名:
        函数体
        返回语句

    # 如中断服务函数：
    # 未定义中断
    Undefined_Handler:              # Undefined_Handler 是函数名
        ldr r0, =Undefined_Handler  # ldr r0, =Undefined_Handler 是函数体
        bx r0                       # bx r0 是函数返回语句，bx 是返回指令，
                                    #   函数返回语句不是必须的

    # SVC 中断
    SVC_Handler:
        ldr r0, =SVC_Handler
        bx r0

    # 预取终止中断
    PrefAbort_Handler:
        ldr r0, =PrefAbort_Handler 
        bx r0
```

## 1.2 常用汇编指令
### 1.2.1 处理器内部数据传输指令MOV-MRS-MSR
![MOV-MRS-MSR指令](../images/32-ARM汇编-处理器内部数据传输命令MOV-MRS-MSR.png)
``` c
    /* MOV 指令用于寄存器数据或立即数拷贝 */
    MOV R0，R1          /* 将寄存器 R1 中的数据传递给 R0，即 R0=R1 */
    MOV R0, #0X12       /* 将立即数 0X12 传递给 R0 寄存器，即 R0=0X12 */

    /* MRS 指令用于读取将特殊寄存器(如 CPSR 和 SPSR)中的数据传递给通用寄存器， */
    /* 要读取特殊寄存器的数据只能使用 MRS 指令 */
    MRS R0, CPSR        /* 将特殊寄存器 CPSR 里面的数据传递给 R0，即 R0=CPSR */

    /* MSR 指令用来将普通寄存器的数据传递给特殊寄存器，*/
    /* 也就是写特殊寄存器，写特殊寄存器只能使用 MSR */
    MSR CPSR, R0        /* 将 R0 中的数据复制到 CPSR 中，即 CPSR=R0 */
```
### 1.2.2 存储器访问指令LDR-STR
![LDR-STR指令](../images/33-存储器访问指令LDR-STR.png)
``` c
    LDR R0, =0X0209C004 /* 将寄存器地址 0X0209C004 加载到 R0 中，即 R0=0X0209C004 */
    LDR R1, [R0]        /* 读取地址 0X0209C004 中的数据到 R1 寄存器中 */

    LDR R0, =0X0209C004 /* 将寄存器地址 0X0209C004 加载到 R0 中，即 R0=0X0209C004 */
    LDR R1, =0X20000002 /* R1 保存要写入到寄存器的值，即 R1=0X20000002 */
    STR R1, [R0]        /* 将 R1 中的值写入到 R0 中所保存的地址中 */

    /* LDR 后面加上 B 或 H，比如按字节操作的指令就是 LDRB 和 STRB */
    /* 按半字操作的指令就是 LDRH 和 STRH */
```
### 1.2.3 压栈和出栈指令PUSH-POP
![PUSH-POP指令](../images/34-压栈出栈指令PUSH-POP.png)
``` c
    /* 堆栈是由高地址向下增长的 */
    PUSH {R0~R3, R12}   /* 将 R0~R3 和 R12 压栈 */
    PUSH {LR}           /* 将 LR 进行压栈 */

    POP {LR}            /* 先恢复 LR */
    POP {R0~R3,R12}     /* 恢复 R0~R3,R12 */

    /* PUSH 和 POP 的另外一种写法是 'STMFD SP!' 和 'LDMFD SP!' */
    STMFD SP!,{R0~R3, R12}  /* R0~R3, R12 入栈 */
    STMFD SP!,{LR}          /* LR 入栈 */

    LDMFD SP!, {LR}         /* 先恢复 LR */
    LDMFD SP!, {R0~R3, R12} /* 再恢复 R0~R3, R12 */
```
![堆栈压栈出栈示意图](../images/35-堆栈压栈出栈示意图.png)
### 1.2.4 跳转指令B-BX-BL-BLX
![跳转指令](../images/36-跳转指令.png)
``` c
    _start:
        ldr sp,=0X80200000  /* 设置栈指针 */
        b main              /* 跳转到 main 函数，不再返回 */

    push {r0, r1}           /* 保存 r0,r1 */
    cps #0x13               /* 进入 SVC 模式，允许其他中断再次进去 */
    bl system_irqhandler    /* 加载 C 语言中断处理函数到 r2 寄存器中，保存返回值 */
    cps #0x12               /* 进入 IRQ 模式 */
    pop {r0, r1} 
    str r0, [r1, #0X10]     /* 中断执行完成，写 EOIR */
```
### 1.2.5 算数运算指令ADD-SUB-SBC-MUL-UDIV-SDIV
![算数运算指令](../images/37-算数运算指令.png)
### 1.2.5 逻辑运算指令
![算数运算指令](../images/38-逻辑运算指令.png)