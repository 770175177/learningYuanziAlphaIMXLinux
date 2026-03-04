
out/led.elf:     file format elf32-littlearm


Disassembly of section .text:

87800000 <_start>:
87800000:	e10f0000 	mrs	r0, CPSR
87800004:	e3c0001f 	bic	r0, r0, #31
87800008:	e3800013 	orr	r0, r0, #19
8780000c:	e129f000 	msr	CPSR_fc, r0
87800010:	e51fd000 	ldr	sp, [pc, #-0]	; 87800018 <_start+0x18>
87800014:	ea000001 	b	87800020 <__main_from_arm>
87800018:	80200000 	.word	0x80200000
8780001c:	00000000 	.word	0x00000000

87800020 <__main_from_arm>:
87800020:	e51ff004 	ldr	pc, [pc, #-4]	; 87800024 <__main_from_arm+0x4>
87800024:	87800167 	.word	0x87800167

Disassembly of section .text.clk_enable:

87800028 <clk_enable>:
87800028:	b480      	push	{r7}
8780002a:	af00      	add	r7, sp, #0
8780002c:	f244 0368 	movw	r3, #16488	; 0x4068
87800030:	f2c0 230c 	movt	r3, #524	; 0x20c
87800034:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
87800038:	601a      	str	r2, [r3, #0]
8780003a:	f244 036c 	movw	r3, #16492	; 0x406c
8780003e:	f2c0 230c 	movt	r3, #524	; 0x20c
87800042:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
87800046:	601a      	str	r2, [r3, #0]
87800048:	f244 0370 	movw	r3, #16496	; 0x4070
8780004c:	f2c0 230c 	movt	r3, #524	; 0x20c
87800050:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
87800054:	601a      	str	r2, [r3, #0]
87800056:	f244 0374 	movw	r3, #16500	; 0x4074
8780005a:	f2c0 230c 	movt	r3, #524	; 0x20c
8780005e:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
87800062:	601a      	str	r2, [r3, #0]
87800064:	f244 0378 	movw	r3, #16504	; 0x4078
87800068:	f2c0 230c 	movt	r3, #524	; 0x20c
8780006c:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
87800070:	601a      	str	r2, [r3, #0]
87800072:	f244 037c 	movw	r3, #16508	; 0x407c
87800076:	f2c0 230c 	movt	r3, #524	; 0x20c
8780007a:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
8780007e:	601a      	str	r2, [r3, #0]
87800080:	f44f 4381 	mov.w	r3, #16512	; 0x4080
87800084:	f2c0 230c 	movt	r3, #524	; 0x20c
87800088:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
8780008c:	601a      	str	r2, [r3, #0]
8780008e:	bf00      	nop
87800090:	46bd      	mov	sp, r7
87800092:	f85d 7b04 	ldr.w	r7, [sp], #4
87800096:	4770      	bx	lr

Disassembly of section .text.led_init:

87800098 <led_init>:
87800098:	b480      	push	{r7}
8780009a:	af00      	add	r7, sp, #0
8780009c:	2368      	movs	r3, #104	; 0x68
8780009e:	f2c0 230e 	movt	r3, #526	; 0x20e
878000a2:	2205      	movs	r2, #5
878000a4:	601a      	str	r2, [r3, #0]
878000a6:	f44f 733d 	mov.w	r3, #756	; 0x2f4
878000aa:	f2c0 230e 	movt	r3, #526	; 0x20e
878000ae:	f241 02b0 	movw	r2, #4272	; 0x10b0
878000b2:	601a      	str	r2, [r3, #0]
878000b4:	f24c 0304 	movw	r3, #49156	; 0xc004
878000b8:	f2c0 2309 	movt	r3, #521	; 0x209
878000bc:	2208      	movs	r2, #8
878000be:	601a      	str	r2, [r3, #0]
878000c0:	f44f 4340 	mov.w	r3, #49152	; 0xc000
878000c4:	f2c0 2309 	movt	r3, #521	; 0x209
878000c8:	2200      	movs	r2, #0
878000ca:	601a      	str	r2, [r3, #0]
878000cc:	bf00      	nop
878000ce:	46bd      	mov	sp, r7
878000d0:	f85d 7b04 	ldr.w	r7, [sp], #4
878000d4:	4770      	bx	lr

Disassembly of section .text.led_on:

878000d6 <led_on>:
878000d6:	b480      	push	{r7}
878000d8:	af00      	add	r7, sp, #0
878000da:	f44f 4340 	mov.w	r3, #49152	; 0xc000
878000de:	f2c0 2309 	movt	r3, #521	; 0x209
878000e2:	681a      	ldr	r2, [r3, #0]
878000e4:	f44f 4340 	mov.w	r3, #49152	; 0xc000
878000e8:	f2c0 2309 	movt	r3, #521	; 0x209
878000ec:	f022 0208 	bic.w	r2, r2, #8
878000f0:	601a      	str	r2, [r3, #0]
878000f2:	bf00      	nop
878000f4:	46bd      	mov	sp, r7
878000f6:	f85d 7b04 	ldr.w	r7, [sp], #4
878000fa:	4770      	bx	lr

Disassembly of section .text.led_off:

878000fc <led_off>:
878000fc:	b480      	push	{r7}
878000fe:	af00      	add	r7, sp, #0
87800100:	f44f 4340 	mov.w	r3, #49152	; 0xc000
87800104:	f2c0 2309 	movt	r3, #521	; 0x209
87800108:	681a      	ldr	r2, [r3, #0]
8780010a:	f44f 4340 	mov.w	r3, #49152	; 0xc000
8780010e:	f2c0 2309 	movt	r3, #521	; 0x209
87800112:	f042 0208 	orr.w	r2, r2, #8
87800116:	601a      	str	r2, [r3, #0]
87800118:	bf00      	nop
8780011a:	46bd      	mov	sp, r7
8780011c:	f85d 7b04 	ldr.w	r7, [sp], #4
87800120:	4770      	bx	lr

Disassembly of section .text.delay_short:

87800122 <delay_short>:
87800122:	b480      	push	{r7}
87800124:	b083      	sub	sp, #12
87800126:	af00      	add	r7, sp, #0
87800128:	6078      	str	r0, [r7, #4]
8780012a:	bf00      	nop
8780012c:	687b      	ldr	r3, [r7, #4]
8780012e:	1e5a      	subs	r2, r3, #1
87800130:	607a      	str	r2, [r7, #4]
87800132:	2b00      	cmp	r3, #0
87800134:	d1fa      	bne.n	8780012c <delay_short+0xa>
87800136:	bf00      	nop
87800138:	370c      	adds	r7, #12
8780013a:	46bd      	mov	sp, r7
8780013c:	f85d 7b04 	ldr.w	r7, [sp], #4
87800140:	4770      	bx	lr

Disassembly of section .text.delay:

87800142 <delay>:
87800142:	b580      	push	{r7, lr}
87800144:	b082      	sub	sp, #8
87800146:	af00      	add	r7, sp, #0
87800148:	6078      	str	r0, [r7, #4]
8780014a:	e003      	b.n	87800154 <delay+0x12>
8780014c:	f240 70ff 	movw	r0, #2047	; 0x7ff
87800150:	f7ff ffe7 	bl	87800122 <delay_short>
87800154:	687b      	ldr	r3, [r7, #4]
87800156:	1e5a      	subs	r2, r3, #1
87800158:	607a      	str	r2, [r7, #4]
8780015a:	2b00      	cmp	r3, #0
8780015c:	d1f6      	bne.n	8780014c <delay+0xa>
8780015e:	bf00      	nop
87800160:	3708      	adds	r7, #8
87800162:	46bd      	mov	sp, r7
87800164:	bd80      	pop	{r7, pc}

Disassembly of section .text.main:

87800166 <main>:
87800166:	b580      	push	{r7, lr}
87800168:	af00      	add	r7, sp, #0
8780016a:	f7ff ff5d 	bl	87800028 <clk_enable>
8780016e:	f7ff ff93 	bl	87800098 <led_init>
87800172:	f7ff ffc3 	bl	878000fc <led_off>
87800176:	f44f 70fa 	mov.w	r0, #500	; 0x1f4
8780017a:	f7ff ffe2 	bl	87800142 <delay>
8780017e:	f7ff ffaa 	bl	878000d6 <led_on>
87800182:	f44f 70fa 	mov.w	r0, #500	; 0x1f4
87800186:	f7ff ffdc 	bl	87800142 <delay>
8780018a:	e7f2      	b.n	87800172 <main+0xc>
