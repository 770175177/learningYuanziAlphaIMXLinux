TARGET	:= libimu6ull

DEBUG		?= 0
FREERTOS	?= 0

CROSS_COMPILE := arm-linux-gnueabihf-
CC 		:= $(CROSS_COMPILE)gcc
AR		:= $(CROSS_COMPILE)ar
OBJNM	:= $(CROSS_COMPILE)nm
OBJDUMP	:= $(CROSS_COMPILE)objdump
OBJCOPY	:= $(CROSS_COMPILE)objcopy
OBJSIZE	:= $(CROSS_COMPILE)size

LDFILE	:= ./devices/MCIMX6Y2/gcc/MCIMX6Y2xxx08_flash.ld
LDDDRADDR	:= 0x87800000

CFLAGS	:= -DCPU_MCIMX6Y2CVM08 \
		-g \
		-Wall \
		-ffunction-sections \
		-fdata-sections \
		-nostdlib \
		-Wall

LDLAGS	:= -O2 \
		-nostartfiles

OUT_DIR	:= out

INC		:= -I./CMSIS/Include \
		-I./CORTEXA/Include \
		-I./devices/MCIMX6Y2 \
		-I./devices/MCIMX6Y2/drivers \
		-I./devices/MCIMX6Y2/utilities \

SRCS	:= devices/MCIMX6Y2/gcc/startup_MCIMX6Y2.S \
		devices/MCIMX6Y2/system_MCIMX6Y2.c \
		$(wildcard devices/MCIMX6Y2/drivers/*.c) \
		$(filter-out %sbrk.c,$(wildcard devices/MCIMX6Y2/utilities/*.c)) \

ifeq ($(FREERTOS), 0)
	SRCS := $(filter-out $(shell grep -il "freertos" $(SRCS)),$(SRCS))
endif

OBJS	:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(patsubst %.S,%.o,$(SRCS))))
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
all: $(TARGET).a
	@echo "Create files $(OUT_DIR)/$(TARGET).symble $(OUT_DIR)/$(TARGET).asm"
	@$(OBJNM) $(OUT_DIR)/$< > $(OUT_DIR)/$(TARGET).symble
	@$(OBJDUMP) -d $(OUT_DIR)/$< > $(OUT_DIR)/$(TARGET).asm

# ar rcs 创建库（若不存在）、替换文件、更新索引
$(TARGET).a: $(OBJS)
	@echo "Link all, Create static Library $(OUT_DIR)/$@"
	@$(AR) rcs $(OUT_DIR)/$@ $(OBJO)
	@$(OBJSIZE) $(OUT_DIR)/$@

# -c 指定编译源文件
%.o: %.c
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(INC) -c $< -o $(OUT_DIR)/$@

%.o: %.s
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(INC) -c $< -o $(OUT_DIR)/$@

%.o: %.S
	@echo "Create Object File $(OUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(INC) -c $< -o $(OUT_DIR)/$@

.PHONY:
clean:
	rm -rf $(OUT_DIR)
