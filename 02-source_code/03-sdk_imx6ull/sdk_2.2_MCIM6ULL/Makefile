LIBIMX6ULL	:= libimu6ull

DEBUG		?= 0
FREERTOS	?= 0

CROSS_COMPILE ?= arm-linux-gnueabihf-
CC 		:= $(CROSS_COMPILE)gcc
AR		:= $(CROSS_COMPILE)ar
OBJNM	:= $(CROSS_COMPILE)nm
OBJDUMP	:= $(CROSS_COMPILE)objdump
OBJCOPY	:= $(CROSS_COMPILE)objcopy

LDFILE	:= devices/MCIMX6Y2/gcc/MCIMX6Y2xxx08_flash.ld
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

IMXOUT_DIR	:= out

IMX_INC		:= -I./CMSIS/Include \
		-I./CORTEXA/Include \
		-I./devices/MCIMX6Y2 \
		-I./devices/MCIMX6Y2/drivers \
		-I./devices/MCIMX6Y2/utilities

SRCS	:= devices/MCIMX6Y2/gcc/startup_MCIMX6Y2.S \
		devices/MCIMX6Y2/system_MCIMX6Y2.c \
		$(wildcard devices/MCIMX6Y2/drivers/*.c) \
		$(filter-out %sbrk.c,$(wildcard devices/MCIMX6Y2/utilities/*.c)) \

ifeq ($(FREERTOS), 0)
	SRCS := $(filter-out $(shell grep -il "freertos" $(SRCS)),$(SRCS))
endif

OBJS	:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(patsubst %.S,%.o,$(SRCS))))
OBJO	:= $(patsubst %.o,$(IMXOUT_DIR)/%.o,$(OBJS))
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
all: $(LIBIMX6ULL).a

export_subvar:
	@echo "LDFILE		:= $(LDFILE)" > $(LIBIMX6ULL).mk
	@echo "LDDDRADDR	:= $(LDDDRADDR)" >> $(LIBIMX6ULL).mk
	@echo "LIBIMX6ULL	:= $(LIBIMX6ULL)" >> $(LIBIMX6ULL).mk
	@echo "IMXOUT_DIR	:= $(IMXOUT_DIR)" >> $(LIBIMX6ULL).mk
	@echo "IMX_INC		:= $(IMX_INC)" >> $(LIBIMX6ULL).mk

# ar rcs 创建库（若不存在）、替换文件、更新索引
$(LIBIMX6ULL).a: $(OBJS)
	@echo "Link to Library, Create static Library $(IMXOUT_DIR)/$@"
	@$(AR) rcs $(IMXOUT_DIR)/$@ $(OBJO)

# -c 指定编译源文件
%.o: %.c
	@echo "Create Object File $(IMXOUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(IMX_INC) -c $< -o $(IMXOUT_DIR)/$@

%.o: %.s
	@echo "Create Object File $(IMXOUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(IMX_INC) -c $< -o $(IMXOUT_DIR)/$@

%.o: %.S
	@echo "Create Object File $(IMXOUT_DIR)/$@"
	@$(CC) $(CFLAGS) $(IMX_INC) -c $< -o $(IMXOUT_DIR)/$@

.PHONY:
clean:
	rm -rf $(IMXOUT_DIR) $(LIBIMX6ULL).a $(LIBIMX6ULL).mk