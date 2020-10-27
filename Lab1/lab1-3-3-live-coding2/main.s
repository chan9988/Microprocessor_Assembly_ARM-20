.data
	arr1: .word 0x19, 0x34, 0x14, 0x32, 0x52, 0x23, 0x61, 0x29
	arr2: .word 0x18, 0x17, 0x33, 0x16, 0xFA, 0x20, 0x55, 0xAC

.text
	.global main

do_sort:
	movs r1, #0
	movs r2, #28
sort:
	ldr r3, [r0,r1]
	add r1, #4
	ldr r4, [r0,r1]
	cmp r3,r4
	blt lt
	cmp r1, r2
	blt	sort
	beq sub

sub:
	sub r2, #4
	movs r1,#0
	cmp r2, #0
	bne sort
	b r

lt:
	strb r3, [r0,r1]
	sub r1, #4
	strb r4, [r0,r1]
	add r1, #4
	cmp r1, r2
	blt	sort
	beq sub

r:
	bx lr

main:
	ldr r0, =arr1
	bl do_sort
	ldr r0, =arr2
	bl do_sort

L: b L
