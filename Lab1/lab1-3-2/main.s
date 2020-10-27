.text
	.global main
	.equ N, 20

fib:
	cmp r0, #0
	blt n101
	cmp r0, #100
	bgt n101
	cmp r0, #0
	beq n0
	cmp r0, #1
	beq n1
	movs r1, #0
	movs r2, #1
cal:
	add r4, r1, r2
	cmp r4, #0
	ble vs
	movs r1, r2
	movs r2, r4
	sub r0, #1
	cmp r0, #1
	bne cal
	b r
n0:
	movs r4, #0
	b r
n1:
	movs r4, #1
	b r
n101:
	movs r4, #0
	sub r4, #1
	b r
vs:
	movs r4, #0
	sub r4, #2
 	b r
r:
	bx lr


main:
	movs R0, #N
	bl fib
L: b L
