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
	.equ c_moder, 0x48000800
	.equ c_idr, 0x48000810

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
	movs r0,#0x5
	ldr r1, =rcc_ahb2enr
	str r0, [r1]

	// led
	ldr r0, =0x5555  // 01 => output mode
	ldr r1, =gpioa_moder
	ldr r2, [r1]
	ldr r3, =0xffff0000
	and r2, r3
	orr r2, r2, r0
	str r2, [r1]
	ldr r0, =0xcccc
	ldr r1, =gpioa_qspeedr
	strh r0,[r1]

	// button
	ldr r1, =c_moder
	ldr r0, [r1]
	ldr r2, =#0xf3ffffff
	and r0,r2  // 00 => input mode
	str r0, [r1]
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
	b r
d0:
	ldr r0, =0xc2
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d1:
	ldr r0, =0xc0
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d2:
	ldr r0, =0x81
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d3:
	ldr r0, =0x03
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d4:
	ldr r0, =0x43
	strh r0, [r1]
	movs r6, #1
	add r5, r6
	strb r5, [r4]
	b r
d7:
	ldr r0, =0xc0
	strh r0, [r1]
	movs r5, #0
	strb r5, [r4]
r:
	BX LR


delay:
	//TODO: Write a delay 1 sec function
	ldr r3, =#730
l1: ldr r4, =#730
	ldr r5, =c_idr
	ldr r6, [r5]
	movs r2, #1
	lsl r2, #13
	and r6, r2
l2: sub r4, #1
	bne l2
	ldr r7, [r5]
	movs r2, #1
	lsl r2, #13
	and r7, r2
	lsr r6, #13
	cmp r6, #0
	beq button
	sub r3, #1
	bne l1
	b end
button:
	lsr r7, #13
	cmp r7, #0
	bne l1
	ldr r6, =leds
	ldr r7, [r6]
	cmp r7, #8
	bne stop
	pop {r7}
	strb r7, [r6]
	ldr r3, =#730
l3: ldr r4, =#730
l4: sub r4, #1
	bne l4
	sub r3, #1
	bne l3
	b end
stop:
	push {r7}
	movs r7, #8
	strb r7, [r6]
	ldr r3, =#730
l5: ldr r4, =#730
l6: sub r4, #1
	bne l6
	sub r3, #1
	bne l5
end:
	bx lr
