.data
	answer: .word 0x3

.text
	.global main
	.equ rcc_ahb2enr, 0x4002104c
	.equ a_moder, 0x48000000
	.equ a_qspeedr, 0x48000008
	.equ a_odr, 0x48000014
	.equ c_moder, 0x48000800
	.equ c_idr, 0x48000810

main:

	BL GPIO_init
	ldr r1, =a_odr
	movs r0, #0
	strh r0, [r1]
input:
	ldr r1, =c_idr
	ldr r0, [r1]
	movs r5, #1
	lsl r5, #13
	and r0, r5
	lsr r0, #13
	bl short_delay
	ldr r2, [r1]
	and r2, r5
	lsr r2, #13
	cmp r0, #0
	beq bu
	b input
bu:
	cmp r2, #0
	bne input
	ldr r1, =c_idr
	ldr r0, [r1]
	ldr r4, =answer
	ldr r3, [r4]
	ldr r5, =0xf
	and r0, r5
	and r3, r5
	cmp r0, r3
	bne false

true:
	ldr r1, =a_odr
	movs r0, #(1<<5)
	strh r0, [r1]
	bl delay
	movs r0, #0
	strh r0, [r1]
	bl delay
	ldr r1, =a_odr
	movs r0, #(1<<5)
	strh r0, [r1]
	bl delay
	movs r0, #0
	strh r0, [r1]
	bl delay
	ldr r1, =a_odr
	movs r0, #(1<<5)
	strh r0, [r1]
	bl delay
	movs r0, #0
	strh r0, [r1]
	b input

false:
	ldr r1, =a_odr
	movs r0, #(1<<5)
	strh r0, [r1]
	bl delay
	movs r0, #0
	strh r0, [r1]
	b input



GPIO_init:
	//TODO: Initial LED GPIO pins as output
	movs r0,#0x5
	ldr r1, =rcc_ahb2enr
	str r0, [r1]
	// led
	ldr r0, =0x400  // 01 => output mode
	ldr r1, =a_moder
	ldr r2, [r1]
	ldr r3, =0xfffff3ff
	and r2, r3
	orr r2, r2, r0
	str r2, [r1]
	ldr r0, =0x800
	ldr r1, =a_qspeedr
	strh r0,[r1]

	// button && switch
	ldr r1, =c_moder
	ldr r0, [r1]
	ldr r2, =#0xf3ffff00
	and r0,r2  // 00 => input mode
	str r0, [r1]
	BX LR

delay:
	ldr r3, =#500
l1:	ldr r4, =#500
l2: sub r4, #1
	bne l2
	sub r3, #1
	bne l1
	bx	lr

short_delay:
	ldr r3, =#1000
l3: sub r3, #1
	bne l3
	bx lr
