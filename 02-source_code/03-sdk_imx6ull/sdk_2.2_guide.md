[TOC]

# 一、SDK移植
SDK 文件为： **SDK_2.2_MCIM6ULL_RFP_Linux.run**。
直接执行，将 sdk 解压到自定义目录 sdk_2.2_MCIM6ULL 中：
```bash
    bash ./sdk_2.2_MCIM6ULL/SDK_2.2_MCIM6ULL_RFP_Linux.run
```
sdk_2.2_MCIM6ULL 目录结构
```bash
boards/evkmcimx6ull
    demo_apps         // freertos_camera/lwip/powermode_switch/sai_sdma_freertos
    driver_examples   // adc/cache/csi/enet/gpio/iic/mmdc/sai/uart/...
    project_template  // 单个工程模板
    rtos_examples     // 许多freertos相关项目模板
    usb_examples      // 许多usb相关项目模板
CMSIS/include
    cmsis_gcc.h       // 只有这一个头文件，arm指令操作接口
CORTEXA/include
    core_ca.h         // 包含了cortexa_gcc.h
    core_ca7.h        // 包含了core_ca.h，封装了CPSR/CP15/L1Cache/MMU/GIC等操作接口
    cortexa_gcc.h     // 包含了cmsis_gcc.h，且增加了MRS/MSR/CPSR等相关指令
devices
    MCIMX6Y2          // 开发板的芯片，包含derivers/lds/utils/MCIMX6Y2.h/start.S等
        drivers       // 各种驱动，adc/cache/clock/csi/enet/gpc/i2c/iomux/pmu/...
        gcc           // lds文件及startup文件，含flash/ram
        utilities     // 有debug_console/io/log/sbrk/str等
        fsl_device_registers.h  // 包含MCIMX6Y2.h及MCIMX6Y2_features.h
        MCIMX6Y2_features.h     // 定义本芯片的各个IP的数量
        MCIMX6Y2.h              // 包含中断号/muxpad相关/adc相关/ahb等地址与配置等
        system_MCIMX6Y2.x       // 包含irq配置，clock配置，systick等相关函数
doc
middleware
    fatfs_0.12c
    lwip_2.0.2
    sdmmc_2.1.2
    usb_1.6.3
rtos/freertos_9.0.0
tools                 // cmake/imgutil/mfgtools
Makefile              // 自定义的Makefile，用于将sdk编译成库
```

# 二、分析lds和start.S及Makefile
## 2.1 将 sdk 编译成 .a 库
``` bash
    # rcs 表示创建库（若不存在）、替换文件、更新索引
    arm-linux-gnueabihf-ar rcs out/libimx6ull.a $(OBJO)
    # 在引用该库的Makefile中，使用-Lout -limx6ull引用库
```
## 2.2 Makefile
``` bash
    # -Wl,-Map=$(OUT_DIR)/$@/$@.map，-Wl表示后面的参数传递给链接器，-map表示生成Map文件
    # objcopy -S -g，-S负责剥离符号表和重定位信息，-g则专注于移除调试符号
    #		  --only-section 或 -j，只拷贝特定的段到bin文件
    # objdump --remove-section 排除特定的段
```
## 2.3 lds文件
``` bash
    # lds 文件的内存布局情况，最终生成的 bin 文件按 LMA 排布： 
    .section : {
        *;
    } > VMA AT (LMA)
    # 若某些段没有显式指定AT(LMA)，链接器默认将LMA设为与VMA相同。当objcopy生成BIN时，它就会在文件中填充巨大的空隙，以匹配这些LMA地址。
    PROVIDE_HIDDEN (__preinit_array_start = .)
    # PROVIDE_HIDDEN 允许你定义仅在链接脚本内部可见的“弱符号”，为跨模块的接口定义和内存布局管理提供了独特的灵活性。
    # 如果程序代码中没有定义这个符号，并且代码中引用了它，那么链接器就使用我在这里提供的定义；如果程序代码中已经定义了这个符号，那么就忽略我的定义。
    .ARM.attributes 0 : { *(.ARM.attributes) }
    # 存放 ARM 相关的架构、版本、标签等元数据。用于确保所有目标文件中的 ARM 属性信息被正确收集并放置在输出文件的指定位置。
    # VMA 为 0，这通常意味着该段的内容在程序运行时不会被加载到内存中执行。
```
## 2.4 利用gcc工具分析各个段
### 2.4.1 readelf -l 查看段信息
``` bash
    arm-linux-gnueabihf-readelf -l 01-sdk_led.elf

Elf file type is EXEC (Executable file)
Entry point 0x800022dc
There are 9 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x010000 0x00900000 0x00900000 0x00024 0x00428 RW  0x10000
  LOAD           0x012000 0x80002000 0x80002000 0x0003c 0x0003c R   0x10000
  LOAD           0x012040 0x80002040 0x80002040 0x551ec 0x551ec RWE 0x10000
  LOAD           0x100000 0x80400000 0x8005722c 0x00f1c 0x00f1c RW  0x10000
  LOAD           0x100f20 0x80400f20 0x80058150 0x00000 0x01be8 RW  0x10000
  NOTE           0x010000 0x00900000 0x00900000 0x00024 0x00024 R   0x4
  NOTE           0x012040 0x80002040 0x80002040 0x00020 0x00020 R   0x4
  TLS            0x100f0c 0x80400f0c 0x80058138 0x00010 0x00028 R   0x4
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10

 Section to Segment mapping:
  Segment Sections...
   00     .note.gnu.build-id .rstack
   01     .interrupts
   02     .note.ABI-tag .text .iplt .ARM.extab __libc_IO_vtables __libc_atexit .ARM .rel.dyn .init_array .fini_array
   03     .data .igot.plt .got .got.plt .tdata
   04     .bss __libc_freeres_ptrs .heap .stack
   05     .note.gnu.build-id
   06     .note.ABI-tag
   07     .tbss .tdata
   08
```
### 2.4.2 readelf -S 查看段信息
``` bash
    arm-linux-gnueabihf-readelf -S 01-sdk_led.elf
There are 39 section headers, starting at offset 0x5675e0:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .note.gnu.build-i NOTE            00900000 010000 000024 00   A  0   0  4
  [ 2] .note.ABI-tag     NOTE            80002040 012040 000020 00   A  0   0  4
  [ 3] .interrupts       PROGBITS        80002000 012000 00003c 00   A  0   0  4
  [ 4] .text             PROGBITS        80002080 012080 0545a4 00  AX  0   0 64
  [ 5] .iplt             PROGBITS        80056624 066624 000010 00  AX  0   0  4
  [ 6] .ARM.extab        PROGBITS        80056634 066634 00026c 00   A  0   0  4
  [ 7] __libc_IO_vtables PROGBITS        800568a0 0668a0 0002f4 00   A  0   0  4
  [ 8] __libc_atexit     PROGBITS        80056b94 066b94 000004 00   A  0   0  4
  [ 9] .ARM              ARM_EXIDX       80056b98 066b98 000680 00  AL  4   0  4
readelf: Warning: [10]: Link field (0) should index a symtab section.
  [10] .rel.dyn          REL             80057218 067218 000008 08   A  0   0  4
  [11] .init_array       INIT_ARRAY      80057220 067220 000004 04  WA  0   0  4
  [12] .fini_array       FINI_ARRAY      80057224 067224 000008 04  WA  0   0  4
  [13] .ncache           PROGBITS        80400000 200000 000000 00   W  0   0 1048576
  [14] .data             PROGBITS        80400000 100000 000eb0 00  WA  0   0 1048576
  [15] .igot.plt         PROGBITS        80400eb0 100eb0 000004 00  WA  0   0  4
  [16] .got              PROGBITS        80400eb4 100eb4 00004c 00  WA  0   0  4
  [17] .got.plt          PROGBITS        80400f00 100f00 00000c 04  WA  0   0  4
  [18] .tbss             NOBITS          80400f0c 100f0c 000018 00 WAT  0   0  4
  [19] .tdata            PROGBITS        80400f0c 100f0c 000010 00 WAT  0   0  4
  [20] OcramData         PROGBITS        00900024 200000 000000 00   W  0   0  1
  [21] .bss              NOBITS          80400f20 100f20 000fcc 00  WA  0   0  8
  [22] __libc_freeres_pt NOBITS          80401eec 100f20 000018 00  WA  0   0  4
  [23] .heap             NOBITS          80401f04 100f20 000404 00  WA  0   0  1
  [24] .stack            NOBITS          80402308 100f20 000800 00  WA  0   0  1
  [25] .ARM.attributes   ARM_ATTRIBUTES  00000000 200000 000039 00      0   0  1
  [26] .rstack           NOBITS          00900024 010024 000404 00  WA  0   0  1
  [27] .comment          PROGBITS        00000000 200039 000024 01  MS  0   0  1
  [28] .debug_aranges    PROGBITS        00000000 200060 002860 00      0   0  8
  [29] .debug_info       PROGBITS        00000000 2028c0 21c926 00      0   0  1
  [30] .debug_abbrev     PROGBITS        00000000 41f1e6 032e19 00      0   0  1
  [31] .debug_line       PROGBITS        00000000 451fff 04f26f 00      0   0  1
  [32] .debug_str        PROGBITS        00000000 4a126e 013dd2 01  MS  0   0  1
  [33] .debug_ranges     PROGBITS        00000000 4b5040 0112b0 00      0   0  8
  [34] .debug_frame      PROGBITS        00000000 4c62f0 008758 00      0   0  4
  [35] .debug_loc        PROGBITS        00000000 4cea48 084a12 00      0   0  1
  [36] .symtab           SYMTAB          00000000 55345c 00d3c0 10     37 2277  4
  [37] .strtab           STRTAB          00000000 56081c 006c35 00      0   0  1
  [38] .shstrtab         STRTAB          00000000 567451 00018f 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  y (purecode), p (processor specific)
```
### 2.4.3 段的分析
| 段名 | 作用说明 |
| ---- | ------- |
| [ 1] .note.gnu.build-i | 数字指纹，用于调试符号匹配（core dump与ELF匹配）、版本唯一标志 |
| [ 2] .note.ABI-tag | 作用是标识可执行文件所要求的运行时ABI环境，**Note Header(nameSZ\|descSZ\|type=1)+Name字段(OS标志如GNU\0)+Descriptor字段(4DW: 0,主版本,次版本,子版本)**， |
| [ *] lds描述的段 | 参考lds文件 |
| [ 5] .iplt  | 该段专门用于支持位置无关代码（PIC）和延迟绑定的特殊节区。即序启动时不会立即解析所有外部函数的实际地址，而是等到函数第一次被调用时才进行解析。 |
| [ 7] __libc_IO_vtables | 作用是提供I/O虚函数表的合法性验证基准，这个段建立了严格的vtable地址白名单机制。 |
| [ 8] __libc_atexit | 专门用于存储通过atexit()或__cxa_atexit()函数注册的清理函数指针，当程序正常终止（通过exit()或从main()返回）时，系统会按照“后进先出”的顺序依次执行这个清单上的所有函数，确保资源被正确释放。 |
| [10]: Link field (0) should index a symtab section. | 这个错误信息表明链接器在处理重定位条目时，发现某个符号的"所属节区索引"字段指向了一个无效或非符号表的节区。 |
| [10] .rel.dyn | 重定位动态段，主要处理那些在编译时地址未知或需要在运行时动态确定的符号引用。侧重于对全局变量、静态变量等数据符号的地址修正。 |
| [15] .igot.plt ||
| [16] .got  ||
| [18] .tbss ||
| [19] .tdata  ||
| [22] __libc_freeres_pt ||
| [25] .ARM.attributes ||
| [27] .comment ||
| [28-35] .debug_* ||
| [36] .symtab ||
| [37] .strtab  ||
| [38] .shstrtab  ||

| 段名称 | 主要功能 | 与.iplt的关系 |
| ----- | -------- | ------------ |
| .plt | 过程链接表，包含跳转到动态链接器的桩代码 | .iplt是.plt的间接版本，用于位置无关代码 |
| .got.plt | 全局偏移表的过程链接表部分，存储函数地址 | .iplt通过.got.plt获取解析后的函数地址 |
| .dynamic | 动态链接信息表，包含动态链接所需的各种信息 | 提供动态链接器解析.iplt所需的信息 |
| .dynsym | 动态符号表，包含需要动态解析的符号信息 | .iplt引用的函数符号在此表中定义 |
### 2.4.4 段的特别说明，在头部生成了标识
若生成的bin文件太大，可能是段不连续或段的跨越太大，且头部生成了类似于2.4.3节[ 2] .note.ABI-tag的数据格式，则可以在链接阶段去掉该段。或在objcopy删除该段。
``` bash
    # 在链接阶段直接告诉链接器不要生成 Build ID
    -Wl,--build-id=none
    # 在objcopy时不拷贝.note.gnu.build-id段
    arm-linux-gnueabihf-objcopy -R .note.gnu.build-id
```

# 三、适配sdk版本裸机程序
## 3.1 led
led软硬件等资料参考: **02-source_code/01-asm_led/01-asm_led_guide.md**
需要配置：
1) PAD-IOMUX 配置引脚复用,**GPIO1_IO3**
2) PAD-CFG 配置引脚属性
3) PAD-GPIO 配置GPIO相关
4) CCM 配置CCM时钟
## 3.2 beep
本开发板使用的是 **有源蜂鸣器**
低电平导通，引脚是 **GPIO5_IO1**
### 3.2.1 蜂鸣器硬件
![GPIO1_IO00](../../images/56-beep原理图.png)
