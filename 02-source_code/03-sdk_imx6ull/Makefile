TARGETS	:= 01-sdk_led \
		02-sdk_beep \

IMXSDK	:= sdk_2.2_MCIM6ULL

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

LDFLAGS	:= -Os \
		-ffunction-sections \
		-fdata-sections \
		-Wl,--gc-sections

LDFLAGS += $(CFLAGS)

OUT_DIR	:= out
TOOLS_DIR	:= ../tools

D 		?= /dev/null

INC		:= $(patsubst %,-I./%,$(TARGETS)) \

SRCS	:= $(wildcard $(patsubst %,%/*.c,$(TARGETS))) \

OBJS	:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(SRCS)))
OBJO	:= $(patsubst %.o,$(OUT_DIR)/%.o,$(OBJS))
DIRS	:= $(dir $(OBJO))
PWD		:= $(shell pwd)

$(shell for dir in $(DIRS); do if [ ! -d $$dir ]; then mkdir -p $$dir; fi done)
$(shell $(MAKE) -s -C $(IMXSDK) export_subvar)

include $(IMXSDK)/*.mk

INC		+= $(IMX_INC)

# $@    规则中的目标集合
# $%    当目标是函数库的时候表示规则中的目标成员名
# $<    依赖文件集合中的第一个文件，若依赖由 % 定义，则 $< 表示符合的所有文件
# $?    所有比目标新的依赖目标集合
# $^    所有依赖文件的集合，会去重
# $+    和 $^ 类似，但不会去重
# $*    目标模式中 % 及之前部分，如目标 test.c，模式 %.c，则 $* 是 test
all: $(TARGETS)
	@echo "Build Complete!"

$(TARGETS): $(LIBIMX6ULL).a $(OBJS)
	@echo "Link all, Create ELF File $(OUT_DIR)/$@/$@.elf"
	@$(CC) $(LDFLAGS) $(shell find $(OUT_DIR)/$@/ -name *.o) $(INC) -o $(OUT_DIR)/$@/$@.elf \
		-L$(OUT_DIR) -l$(patsubst lib%,%,$(LIBIMX6ULL)) \
		-T$(IMXSDK)/$(LDFILE) \
		-Wl,-Map=$(OUT_DIR)/$@/$@.map
	@$(OBJSIZE) $(OUT_DIR)/$@/$@.elf
	@echo "Create files $(OUT_DIR)/$@/$@.asm $(OUT_DIR)/$@/$@.bin $(OUT_DIR)/$@/$@.hex"
	@$(OBJDUMP) -d $(OUT_DIR)/$@/$@.elf > $(OUT_DIR)/$@/$@.asm
	@$(OBJCOPY) -O binary -S -g $(OUT_DIR)/$@/$@.elf $(OUT_DIR)/$@/$@.bin
	@$(OBJCOPY) -O ihex $(OUT_DIR)/$@/$@.elf $(OUT_DIR)/$@/$@.hex

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
	@$(CC) $(CFLAGS) -c $< -o $(OUT_DIR)/$@

%.o: %.s
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) -c $< -o $(OUT_DIR)/$@

.PHONY:
burn:
	@echo "Load $() to Device $(D)"
	chmod +x $(TOOLS_DIR)/imxdownload
	$(TOOLS_DIR)/imxdownload $(TARGETS).bin $(D)

.PHONY:
clean:
	rm -rf $(OUT_DIR) load.imx
	$(MAKE) -C $(IMXSDK) clean
