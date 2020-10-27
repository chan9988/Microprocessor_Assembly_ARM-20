	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	result: .zero 8

.text

.global main
	.equ X, 0x00ff00ff
	.equ Y, 0x101
main:
	LDR R0, =X
	LDR R1, =Y
	LDR R2, =result
	BL kara_mul
L:
	B L

kara_mul:
	//TODO: Separate the leftmost and rightmost halves into different registers; then do the Karatsuba algorithm.
	// r3=Xl r4=Xr r5=Yl r6=Yr
	umull r11, r12, r0, r1

	mov r3, r0
	mov r4, r0
	mov r5, r1
	mov r6, r1
	lsr r3, #16
	lsr r5, #16
	mov r7, #0xffff
	and r4, r7
	and r6, r7
	mul r7, r3, r5
	mul r8, r4, r6
	add r3, r4
	add r4, r5, r6
	umull r5, r6, r3, r4
	ldr r10, =0x0
	adds r7, r8
	adc r10, #0
	cmp r5, r7
	beq hi
	bhi hi
	bls ls
hi:
	sub r5, r7
	sub r6, r10
	b cal
ls:
	ldr r9, =0xffffffff
	sub r9, r7
	sub r6, #1
	add r5, r9
	add r5, #1
	sub r6, r10
	b cal
cal:
	sub r7, r8
	mov r9, r5
	lsl r5, #16
	lsl r6, #16
	lsr r9, #16
	add r6, r9
	adds r5, r5, r8
	adc r6, r6, r7
	strd r6, r5, [r2]

	bx lr
