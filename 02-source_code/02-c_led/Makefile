TARGET	:= led

CROSS_COMPILE := arm-linux-gnueabihf-
CC 		:= $(CROSS_COMPILE)gcc
LD 		:= $(CROSS_COMPILE)ld
OBJDUMP	:= $(CROSS_COMPILE)objdump
OBJCOPY	:= $(CROSS_COMPILE)objcopy
OBJSIZE	:= $(CROSS_COMPILE)size

LDFILE	:= ./imx6ul.ld
LDDDRADDR	:= 0x87800000

CFLAGS	:= -g \
		-ffunction-sections \
		-fdata-sections \

LDLAGS	:= -Os \
		-nostartfiles

OUT_DIR	:= out
TOOLS_DIR	:= ../tools

D 		?= /dev/null

INC		:= 

SRCS	:= start.s \
		led.c

OBJS	:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(SRCS)))
OBJO	:= $(patsubst %.o,$(OUT_DIR)/%.o,$(OBJS))
DIRS	:= $(dir $(OBJO))
PWD		:= $(shell pwd)

$(shell for dir in $(DIRS); do if [ ! -d $$dir ]; then mkdir -p $$dir; fi done)


# $@    规则中的目标集合
# $%    当目标是函数库的时候表示规则中的目标成员名
# $<    依赖文件集合中的第一个文件，若依赖由 % 定义，则 $< 表示符合的所有文件
# $?    所有比目标新的依赖目标集合
# $^    所有依赖文件的集合，会去重
# $+    和 $^ 类似，但不会去重
# $*    目标模式中 % 及之前部分，如目标 test.c，模式 %.c，则 $* 是 test
all: $(TARGET).elf
	@echo "Create files $(OUT_DIR)/$(TARGET).asm $(OUT_DIR)/$(TARGET).bin $(OUT_DIR)/$(TARGET).hex"
	@$(OBJDUMP) -d $(OUT_DIR)/$< > $(OUT_DIR)/$(TARGET).asm
	@$(OBJCOPY) -O binary -S -g $(OUT_DIR)/$< $(OUT_DIR)/$(TARGET).bin
	@$(OBJCOPY) -O ihex $(OUT_DIR)/$< $(OUT_DIR)/$(TARGET).hex
	@cp $(OUT_DIR)/$(TARGET).bin ./

$(TARGET).elf: $(OBJS)
	@echo "Link all, Create ELF File $(OUT_DIR)/$@"
	@$(LD) $(LDLAGS) $(OBJO) -o $(OUT_DIR)/$@ \
		-T$(LDFILE) \
		-Map $(OUT_DIR)/$(TARGET).map
	@$(OBJSIZE) $(OUT_DIR)/$@

# -c 指定编译源文件
%.o: %.c
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) -c $< -o $(OUT_DIR)/$@

%.o: %.s
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) -c $< -o $(OUT_DIR)/$@

.PHONY:
burn:
	@echo "Load to Device $(D)"
	chmod +x $(TOOLS_DIR)/imxdownload
	$(TOOLS_DIR)/imxdownload $(TARGET).bin $(D)

.PHONY:
clean:
	rm -rf $(OUT_DIR) $(TARGET).bin load.imx
