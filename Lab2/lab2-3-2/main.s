	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	infix_expr: .asciz "]{ -99 + [ 10 + 20 - 0] }"
	user_stack_bottom: .zero 128

.text
	.global main
	//infix_expr: .asciz "{{ -99 + [ 10 + 20 - 0 ] }}"
	//move infix_expr here. Please refer to the question below.

main:
	BL stack_init
	LDR R0, =infix_expr
	BL pare_check
L: B L

stack_init:
	//TODO: Setup the stack pointer(sp) to user_stack.
	ldr sp, =user_stack_bottom
	add sp, #128
	mov r4, sp
	BX LR

pare_check:
	//TODO: check parentheses balance, and set the error code to R0
read:
	ldrb r2, [r0]
	add r0, #1
	cmp r2, #00
	beq check
	cmp r2, #91
	beq pu
	cmp r2, #93
	beq po
	cmp r2, #123
	beq pu
	cmp r2, #125
	beq po
	b read
pu:
	push {r2}
	b read
po:
	cmp sp,r4
	beq wrong
	pop {r3}
	add r3, #2
	cmp r2,r3
	beq read
	bne wrong
check:
	cmp sp, r4
	bne wrong
	movs r0, #0
	b r
wrong:
	ldr r0, =-1
	b r
r:
	BX LR
