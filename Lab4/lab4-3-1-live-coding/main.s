	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	//TODO: put 0 to F 7-Seg LED pattern here
	arr: .byte 0x1c, 0x19, 0x15, 0x0d, 0x1c, 0x19, 0x15, 0x0d

.text
	.global main
	.equ rcc_ahb2enr, 0x4002104c
	.equ c_base, 0x48000800
	.equ c_moder, 0x48000800
	.equ c_otyper, 0x48000804
	.equ c_qspeedr, 0x48000808
	.equ c_pupdr, 0x4800080c
	.equ c_odr, 0x48000814
	.equ c_bsrr, 0x48000818
	.equ c_brr, 0x48000828

	.equ data, 0x4
	.equ load, 0x2
	.equ clock, 0x1


main:
	BL GPIO_init
	BL max7219_init

loop:
	BL DisplayDigit
	B loop

GPIO_init:
	//TODO: Initialize GPIO pins for max7219 DIN, CS and CLK
	movs r0,#0x4
	ldr r1, =rcc_ahb2enr
	str r0, [r1]

	ldr r0, =0x15  // 01 => output mode
	ldr r1, =c_moder
	ldr r2, [r1]
	ldr r3, =0xffffffc0
	and r2, r3
	orr r2, r2, r0
	str r2, [r1]

	ldr r0, =0x2a
	ldr r1, =c_qspeedr
	strh r0,[r1]

	BX LR

DisplayDigit:
	//TODO: Display 0 to F at first digit on 7-SEG LED.
	push {lr}
	ldr r9, =arr
	ldr r2, =#0
	mov r3, #1
	mov r4, #0
display:
	mov r0, r4
	mov r1, #0
	bl MAX7219Send
	mov r0, r3
	ldrb r1, [r9,r2]
	bl MAX7219Send
	bl delay
	add r3, r3, #1
	add r4, r4, #1
	add r2, r2, #1
	ldr r5, =#0x8
	cmp r2, r5
	bne display
	mov r0, r4
	mov r1, #0
	bl MAX7219Send
	bl delay
	pop {pc}
	BX LR


MAX7219Send:
	//input parameter: r0 is ADDRESS , r1 is DATA
	//TODO: Use this function to send a message to max7219
	push {r0,r1,r2,r3,r4,r5,r9}
	lsl r0, r0, #8
	add r0, r0, r1
	ldr r2, =#load
	ldr r3, =#data
	ldr r4, =#clock
	ldr r5, =#c_bsrr
	ldr r6, =#c_brr
	mov r7, #16
send_loop:
	mov r8,#1
	sub r9,r7, #1
	lsl r8, r8, r9
	str r4, [r6]  // clock reset
	tst r0, r8
	beq bit_not_set
	str r3, [r5] // data set
	b done
bit_not_set:
	str r3, [r6] // data reset
done:
	str r4, [r5] // clock set
	sub r7, r7, #1
	movs r1, #0
	cmp r7, r1
	bgt send_loop
	str r2, [r6] // load set
	str r2, [r5] // load reseet
	pop {r0,r1,r2,r3,r4,r5,r9}
	BX LR


max7219_init:
	//TODO: Initialize max7219 registers
	push {lr}
	ldr r0, =#0x9  // decode mode
	ldr r1, =#0x0  // no decode for code B
	bl MAX7219Send
	ldr r0, =#0xf  // display test
	ldr r1, =#0x0  //  off(normal display)
	bl MAX7219Send
	ldr r0, =#0xa  // intensity
	ldr r1, =#0xa
	bl MAX7219Send
	ldr r0, =#0xb  // scan limit
	ldr r1, =#0x7
	bl MAX7219Send
	ldr r0, =#0xc  // shutdown
	ldr r1, =#0x1  // off(normal display)
	bl MAX7219Send
	mov r0, #1
	mov r1, #0
blank:
	bl MAX7219Send
	add r0, #1
	cmp r0, #9
	bne blank
	pop {pc}
	BX LR

delay:
	//TODO: Write a delay 1sec function
	push {r3,r4}
	ldr r3, =#700
l1: ldr r4, =#700
l2: sub r4, #1
	cmp r4, #0
	bne l2
	sub r3, #1
	cmp r3, #0
	bne l1
	pop {r3,r4}
	bx lr
