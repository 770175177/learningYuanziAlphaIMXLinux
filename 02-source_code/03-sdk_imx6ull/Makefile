TARGETS	:= 01-sdk_led \
		02-sdk_beep \

IMXSDK	:= sdk_2.2_MCIMX6ULL
IMXBSP	:= sdk_2.2_bsp


CROSS_COMPILE := arm-linux-gnueabihf-
CC 		:= $(CROSS_COMPILE)gcc
LD 		:= $(CROSS_COMPILE)ld
OBJDUMP	:= $(CROSS_COMPILE)objdump
OBJCOPY	:= $(CROSS_COMPILE)objcopy
OBJSIZE	:= $(CROSS_COMPILE)size

CFLAGS	:= -g \
		-static \
		-mcpu=cortex-a7 \
		-mfpu=neon-vfpv4 \
		-mfloat-abi=hard \
		-DCPU_MCIMX6Y2CVM08

LDFLAGS	:= -Os \
		-ffunction-sections \
		-fdata-sections \
		-Wl,--gc-sections

LDFLAGS += $(CFLAGS)

OUT_DIR	:= out
TOOLS_DIR		:= ../tools
GDBCMD_SCRIPT	:= gdb.script

D 		?= /dev/null
T       ?= $(firstword $(TARGETS))

SRCS	:= $(wildcard $(patsubst %,%/*.c,$(TARGETS))) \

BSP_SRC	:= $(wildcard $(IMXBSP)/*/*.c) \
		   $(wildcard $(IMXBSP)/*.c)

OBJS	:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(SRCS) $(BSP_SRC)))
INC		:= $(patsubst %,-I./%,$(dir $(OBJS)))
OBJO	:= $(patsubst %.o,$(OUT_DIR)/%.o,$(OBJS))
BSPO	:= $(patsubst %.c,$(OUT_DIR)/%.o,$(BSP_SRC))
DIRS	:= $(dir $(OBJO))
PWD		:= $(shell pwd)

$(shell for dir in $(DIRS); do if [ ! -d $$dir ]; then mkdir -p $$dir; fi done)
$(shell $(MAKE) -s -C $(IMXSDK) export_subvar)

include $(IMXSDK)/*.mk

INC		+= -I./$(IMXBSP)
INC		+= $(patsubst -I.%,-I./$(IMXSDK)%,$(IMX_INC))

# xx:
# 	@echo $(INC)

# $@    规则中的目标集合
# $%    当目标是函数库的时候表示规则中的目标成员名
# $<    依赖文件集合中的第一个文件，若依赖由 % 定义，则 $< 表示符合的所有文件
# $?    所有比目标新的依赖目标集合
# $^    所有依赖文件的集合，会去重
# $+    和 $^ 类似，但不会去重
# $*    目标模式中 % 及之前部分，如目标 test.c，模式 %.c，则 $* 是 test
all: $(TARGETS)
	@echo "Build Complete!"

# -Wl,-Map=$(OUT_DIR)/$@/$@.map，-Wl表示后面的参数传递给链接器，-map表示生成Map文件
# -Wl,--build-id=none 在链接阶段直接告诉链接器不要生成 Build ID。
# objcopy -S -g，-S负责剥离符号表和重定位信息，-g则专注于移除调试符号
#		  --only-section 或 -j，只拷贝特定的段
#		  -R 选项在生成 .bin 时移除特定的，如.note.gnu.build-id
# objdump --remove-section 排除特定的段
# lds 文件的内存布局情况： .section {} > VMA AT LMA，最终生成的 bin 文件是按 LMA 排布
$(TARGETS): $(LIBIMX6ULL).a $(OBJS)
	@echo "\nLink all, Create ELF File $(OUT_DIR)/$@/$@.elf"
	@$(CC) $(LDFLAGS) $(shell find $(OUT_DIR)/$@/ -name *.o) $(BSPO) $(INC) -o $(OUT_DIR)/$@/$@.elf \
		-L$(OUT_DIR) -l$(patsubst lib%,%,$(LIBIMX6ULL)) \
		-T$(IMXSDK)/$(LDFILE) \
		-Wl,-Map=$(OUT_DIR)/$@/$@.map
	@$(OBJSIZE) $(OUT_DIR)/$@/$@.elf
	@echo "Create files $(OUT_DIR)/$@/$@.asm $(OUT_DIR)/$@/$@.bin $(OUT_DIR)/$@/$@.hex"
	@$(OBJDUMP) -d $(OUT_DIR)/$@/$@.elf > $(OUT_DIR)/$@/$@.asm
	@$(OBJCOPY) -O binary -S -g -R .note.gnu.build-id \
		$(OUT_DIR)/$@/$@.elf $(OUT_DIR)/$@/$@.bin
	@hexdump -C $(OUT_DIR)/$@/$@.bin > $(OUT_DIR)/$@/$@.txt

$(LIBIMX6ULL).a: $(IMXSDK)
	@echo "Build $(IMXSDK) sdk as library $(LIBIMX6ULL).a and copy to $(OUT_DIR)"
	@$(MAKE) -C $(IMXSDK) all
	@cp $(IMXSDK)/$(IMXOUT_DIR)/$(LIBIMX6ULL).a $(OUT_DIR)/
	@echo "---"
	@echo "LD file is $(IMXSDK)/$(LDFILE)"
	@echo "LD addr is $(LDDDRADDR)"
	@echo "SP addr is $(SPDDRADDR)"
	@echo "---"

# -c 指定编译源文件
%.o: %.c
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(INC) -c $< -o $(OUT_DIR)/$@

%.o: %.s
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(INC) -c $< -o $(OUT_DIR)/$@

# -S: 启动即暂停
# -s: 在1234端口监听GDB
# -kernel: 要执行的程序
# -dtb：指定设备树文件
# -device sd-card,drive=mysdcard：添加设备
# -append "console=ttymxc0,115200 root=/dev/mmcblk1 rw"：传递给kernel的参数
.PHONY:
qemu:
	@echo "Execute qemu mcimx6ul-evk on port 1234, Ctrl + a -> x to exit"
	qemu-system-arm -M mcimx6ul-evk -m 512M -kernel \
		$(OUT_DIR)/01-sdk_led/01-sdk_led.bin -nographic -s -S

.PHONY:
gdb:
	@echo "Execute gdb to debug"
	@echo "set architecture arm\ntar remote $(REMOTE_IP):1234\n \
		load\nlayout src\n" > \
		$(OUT_DIR)/$(GDBCMD_SCRIPT)
	@gdb-multiarch $(OUT_DIR)/01-sdk_led/01-sdk_led.elf -x $(OUT_DIR)/$(GDBCMD_SCRIPT)

.PHONY:
burn:
	@echo "Load ./$(OUT_DIR)/$(T)/$(T).bin to Device $(D)"
	@chmod +x $(TOOLS_DIR)/imxdownload
	@$(TOOLS_DIR)/imxdownload ./$(OUT_DIR)/$(T)/$(T).bin $(D)

.PHONY:
clean:
	rm -rf $(OUT_DIR) load.imx
	$(MAKE) -C $(IMXSDK) clean
