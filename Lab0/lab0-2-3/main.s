	.syntax unified
	.cpu cortex-m4
	.thumb

.bss
	Z: .word

.data
	X: .word 100
	str: .asciz "Hello World!"

.text
	.global main
	.equ AA, 0x55

main:
	ldr r1, =X
	ldr r0, [r1]
	movs r2, #AA
	adds r2, r2, r0
	str r2, [r1]

	ldr r1, =str
	ldr r2, [r1]

	ldrh r3, [r1,#4]
	ldr r5, =X
	ldr r4, [r5]
	ldr r6, [r5]
	adds r4, r6
	adds r4, r6
	ldr r7, =Z
	str r4, [r7]

L: B L
