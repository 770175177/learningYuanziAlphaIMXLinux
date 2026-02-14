[TOC]

# 一、IMX6U_SOC地址映射

| 存储介质 | 地址范围 | 说明 |
| ------- | -------- | --- |
| boot ROM | （96KB） | NXP内部使用，支持NorFlash、NANDFlash、SD/eMMC、SPINorFlash和QSPIFlash启动 |
| inner SRAM | 0X900000~0X91FFFF（128KB） | 内部 SRAM |
| DDR | 0X80000000~0X8FFFFFFF（256MB） | DDR3L |