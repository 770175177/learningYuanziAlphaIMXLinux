[TOC]

# 一、SDK移植
SDK 文件为： **SDK_2.2_MCIM6ULL_RFP_Linux.run**。
直接执行，将 sdk 解压到自定义目录 sdk_2.2_MCIM6ULL 中：
```bash
    bash SDK_2.2_MCIM6ULL_RFP_Linux.run
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
doc
middleware
    fatfs_0.12c
    lwip_2.0.2
    sdmmc_2.1.2
    usb_1.6.3
rtos/freertos_9.0.0
tools                 // cmake/imgutil/mfgtools
```
# 二、