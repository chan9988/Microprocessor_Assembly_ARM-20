	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	//TODO: put 0 to F 7-Seg LED pattern here
	number: .word 0
	pre: .word 0
	press: .word 1
	max: .word 99999999
	digit: .word 10000000,1000000,100000,10000,1000,100,10,1

.text
	.global main
	.equ rcc_ahb2enr, 0x4002104c
	.equ c_base, 0x48000800
	.equ c_moder, 0x48000800
	.equ c_otyper, 0x48000804
	.equ c_qspeedr, 0x48000808
	.equ c_pupdr, 0x4800080c
	.equ c_idr, 0x48000810
	.equ c_odr, 0x48000814
	.equ c_bsrr, 0x48000818
	.equ c_brr, 0x48000828

	.equ data, 0x4
	.equ load, 0x2
	.equ clock, 0x1


main:
	BL GPIO_init
	BL max7219_init
	bl display_number
loop:
	BL buttom
	bl fi        // Fibonacci
	bl display_number
	bl delay  // little delay
	b loop


buttom:
	ldr r1, =c_idr
	ldr r0, [r1]
	mov r2, #1
	lsr r0, #13
	and r0, r2
	cmp r0, #0
	bne buttom
	ldr r3, =#2000
b1:				  //  press
	sub r3, #1
	cmp r3, #0
	bne b1        // little delay
	ldr r0, [r1]  // check again
	mov r2, #1
	lsr r0, #13
	and r0, r2
	cmp r0, #0
	bne buttom
	// check press
	ldr r3, =#600   // check many times in two for loop
b2: ldr r4, =#600
b3: sub r4, #1
	cmp r4, #0
	bne b3
	ldr r0, [r1]
	mov r2, #1
	lsr r0, #13
	and r0, r2
	cmp r0, #1
	beq short
	sub r3, #1
	cmp r3, #0
	bne b2          // check short press end
    // long press
	ldr r1, =press
	mov r0, #2
	str r0, [r1]
	b end_buttom
short:
	ldr r1, =press
	mov r0, #1
	str r0, [r1]
	b end_buttom
end_buttom:
	bx lr

fi:
	ldr r2, =number
	ldr r3, =pre
	ldr r0, [r2]
	ldr r1, [r3]
	ldr r4, =press
	ldr r5, [r4]
	cmp r5, #2
	beq long_press
short_press:
	ldr r4, =max
	ldr r5, [r4]
	cmp r0, #0
	beq one
	mov r6, r0
	add r0, r1
	mov r1, r6
	str r0, [r2]
	str r1, [r3]
	cmp r0,r5
	blt end_fi
	ldr r0, =#99999999
	str r0, [r2]
	b end_fi
long_press:
	mov r0, #0
	str r0, [r2]
	str r0, [r3]
	b end_fi
one:
	mov r0, #1
	str r0, [r2]
end_fi:
	bx lr


display_number:
	push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,lr}
	ldr r1, =max
	ldr r0, [r1]
	ldr r9, =number
	ldr r1, [r9]
	cmp r1, #0
	bne not_zero
	ldr r0, =#0xb  // scan limit // digit number ==> r1
	ldr r1, =#0
	bl MAX7219Send
	mov r0, #1
	ldr r1, =#0x0
	bl MAX7219Send
	b end
not_zero:
	cmp r1, r0
	bgt gt
	mov r2, r1
	ldr r3, =#10
	mov r1, #0
	cmp r3, r2
	bgt cal
	ldr r3, =#100
	mov r1, #1
	cmp r3, r2
	bgt cal
	ldr r3, =#1000
	mov r1, #2
	cmp r3, r2
	bgt cal
	ldr r3, =#10000
	mov r1, #3
	cmp r3, r2
	bgt cal
	ldr r3, =#100000
	mov r1, #4
	cmp r3, r2
	bgt cal
	ldr r3, =#1000000
	mov r1, #5
	cmp r3, r2
	bgt cal
	ldr r3, =#10000000
	mov r1, #6
	cmp r3, r2
	bgt cal
	ldr r3, =#100000000
	mov r1, #7
	cmp r3, r2
	bgt cal
cal:
	ldr r0, =#0xb  // scan limit // digit number ==> r1
	bl MAX7219Send
	ldr r4, =digit
	movs r5, #0
digit_num:
	mov r10, #4
	mul r9, r5, r10
	ldr r3, [r4,r9]
	cmp r3, r2
	bgt next
	b d2
d1:
	mov r10, #4
	mul r9, r5, r10
	ldr r3, [r4,r9]
d2:
	movs r6, #10
d:
	sub r6, r6, #1
	mul r7, r6, r3
	cmp r7, r2
	bgt d
	sub r2, r2, r7
	movs r8, #8
	sub r0, r8, r5
	movs r1, r6
	bl MAX7219Send
	add r5, r5, #1
	cmp r5, #8
	bne d1
	b end
next:
	add r5, r5, #1
	cmp r5, #8
	bne digit_num
	b end
gt:
	ldr r0, =#0xb  // scan limit
	ldr r1, =#0x7  // digit 0~7
	bl MAX7219Send
	mov r0, #1
	ldr r1, =#0x9
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
	add r0, #1
	bl MAX7219Send
end:
	pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,pc}
	bx lr


GPIO_init:
	//TODO: Initialize GPIO pins for max7219 DIN, CS and CLK
	movs r0,#0x4
	ldr r1, =rcc_ahb2enr
	str r0, [r1]

	// data(DIN) => pc2   load(CS) => pc1  CLK => pc0
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

	// buttom  PC13
	ldr r1, =c_moder
	ldr r0, [r1]
	ldr r2, =#0xf3ffffff
	and r0,r2  // 00 => input mode
	str r0, [r1]

	ldr r1, =c_pupdr
	ldr r0, [r1]
	ldr r2, =#0x01000000
	str r2, [r1]

	BX LR


MAX7219Send:
	//input parameter: r0 is ADDRESS , r1 is DATA
	//TODO: Use this function to send a message to max7219
	push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9}
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
	pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9}
	BX LR


max7219_init:
	//TODO: Initialize max7219 registers
	push {lr}
	ldr r0, =#0x9  // decode mode
	ldr r1, =#0xff  // decode for code B on digit 0~7
	bl MAX7219Send
	ldr r0, =#0xf  // display test
	ldr r1, =#0x0  //  off(normal display)
	bl MAX7219Send
	ldr r0, =#0xa  // intensity
	ldr r1, =#0xa
	bl MAX7219Send
	ldr r0, =#0xb  // scan limit
	ldr r1, =#0x6  // only digit 0~6
	bl MAX7219Send
	ldr r0, =#0xc  // shutdown
	ldr r1, =#0x1  // off(normal display)
	bl MAX7219Send
	pop {pc}
	BX LR

delay:
	//TODO: Write a delay 1 sec function
	ldr r1, =c_idr
	ldr r0, [r1]
	mov r2, #1
	lsr r0, #13
	and r0, r2
	cmp r0, #1
	bne delay
	ldr r3, =#300
l1: ldr r4, =#300
l2: sub r4, #1
	cmp r4, #0
	bne l2
	sub r3, #1
	cmp r3, #0
	bne l1
	bx lr

