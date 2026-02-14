TARGET	:= led

CROSS_COMPILE := arm-linux-gnueabihf-
CC 		:= $(CROSS_COMPILE)gcc
LD 		:= $(CROSS_COMPILE)ld
OBJDUMP	:= $(CROSS_COMPILE)objdump
OBJCOPY	:= $(CROSS_COMPILE)objcopy
OBJSIZE	:= $(CROSS_COMPILE)size

LDDDRADDR	:= 0x87800000
CFLAGS	:= -g \
		-Os \
		-ffunction-sections \
		-fdata-sections \
		-nostartfiles

SRCS	:= led.s

OBJS	:= $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(SRCS)))
OBJO	:= $(OBJS)

LOAD_DEV ?= /dev/null

# $@    规则中的目标集合
# $%    当目标是函数库的时候表示规则中的目标成员名
# $<    依赖文件集合中的第一个文件，若依赖由 % 定义，则 $< 表示符合的所有文件
# $?    所有比目标新的依赖目标集合
# $^    所有依赖文件的集合，会去重
# $+    和 $^ 类似，但不会去重
# $*    目标模式中 % 及之前部分，如目标 test.c，模式 %.c，则 $* 是 test
all: $(TARGET).elf
	@echo "Create bin file $@"
	@$(OBJDUMP) -d $< > $(TARGET).asm
	@$(OBJCOPY) -O binary -S -g $< $(TARGET).bin
	@$(OBJCOPY) -O ihex $< $(TARGET).hex

$(TARGET).elf: $(OBJS)
	@echo "Link all, Create ELF File $@"
	@$(LD) $(OBJO) -o $@ \
		-Ttext $(LDDDRADDR) \
		-Map $(TARGET).map
	@$(OBJSIZE) $@

# -c 指定编译源文件
%.o: %.c
	@echo "Create Object File $@"
	@$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	@echo "Create Object File $@"
	@$(CC) $(CFLAGS) -c $< -o $@

.PHONY:
install:
	@echo "Load to Device $(LOAD_DEV)"
	chmod +x imxdownload
	./imxdownload $(TARGET).bin $(LOAD_DEV)

.PHONY:
clean:
	rm -rf led.asm led.bin led.hex led.elf led.o led.map