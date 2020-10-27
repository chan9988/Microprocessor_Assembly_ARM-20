.data
	result: .byte 0

.text

.global main
	.equ X, 0x55AA00
	.equ Y, 0xAA5500

main:
	//movs R0, #X //This line will cause an error. Why?
	//movs R1, #Y
	ldr r0, =X
	ldr r1, =Y
	ldr r2, =result
	bl hamm
L: b L

hamm:
	ldrb r3, [r2]
	eor r0,r0,r1
	mov r5, #31
cal:
	movs r4, #1
	and r4, r4, r0
	add r3, r4
	lsr r0, #1
	sub r5, #1
	cmp r5, #0
	bne cal
	strb r3, [r2]

	bx lr
