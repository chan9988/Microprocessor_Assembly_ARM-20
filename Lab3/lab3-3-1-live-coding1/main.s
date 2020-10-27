.data
	leds: .byte 0

.text
	.global main
	.equ rcc_ahb2enr, 0x4002104c
	.equ gpioa_moder, 0x48000000
	.equ gpioa_otyper, 0x48000004
	.equ gpioa_qspeedr, 0x48000008
	.equ gpioa_pupdr, 0x4800000c
	.equ gpioa_odr, 0x48000014

main:
	BL GPIO_init
	MOVS R1, #1
	LDR R0, =leds
	STRB R1, [R0]

Loop:
	//TODO: Write the display pattern into leds variable
	BL DisplayLED
	bl delay
	B Loop

GPIO_init:
	//TODO: Initial LED GPIO pins as output
	movs r0,#0x1
	ldr r1, =rcc_ahb2enr
	str r0, [r1]

	ldr r0, =0x5555
	ldr r1, =gpioa_moder
	ldr r2, [r1]
	ldr r3, =0xffff0000
	and r2, r3
	orr r2, r2, r0
	str r2, [r1]

	ldr r0, =0xcccc
	ldr r1, =gpioa_qspeedr
	strh r0,[r1]

	BX LR

DisplayLED:
	//TODO: Display LED by leds
	ldr r1, =gpioa_odr
	ldr r4, =leds
	ldr r5, [r4]
	cmp r5, #0
	beq d0
	cmp r5, #1
	beq d1
	cmp r5, #2
	beq d2
	cmp r5, #3
	beq d3
	cmp r5, #4
	beq d4
	cmp r5, #5
	beq d3
	cmp r5, #6
	beq d2
	cmp r5, #7
	beq d7
d0:
	ldr r0, =0xc2
	ldr r2, =0xc3
	eor r0, r2
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d1:
	ldr r0, =0xc0
	ldr r2, =0xc3
	eor r0, r2
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d2:
	ldr r0, =0x81
	ldr r2, =0xc3
	eor r0, r2
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d3:
	ldr r0, =0x03
	ldr r2, =0xc3
	eor r0, r2
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d4:
	ldr r0, =0x43
	ldr r2, =0xc3
	eor r0, r2
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d7:
	ldr r0, =0xc0
	ldr r2, =0xc3
	eor r0, r2
	strh r0, [r1]
	movs r5, #0
	strb r5, [r4]
r:
	BX LR


delay:
	//TODO: Write a delay 1 sec function
	ldr r3, =#730
l1: ldr r4, =#730
l2: sub r4, #1
	bne l2
	sub r3, #1
	bne l1
	bx lr
