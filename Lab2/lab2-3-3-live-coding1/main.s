.data
	result: .word 0
	max_size: .word 0

.text
	m: .word 25
	n: .word 30

GCD:
	//TODO: Implement your GCD function
	push {lr}
	add r2, #4
	cmp r2, r3
	ble ch
	mov r3, r2
ch:
	cmp r0, #0
	beq rb
	cmp r1, #0
	beq ra
	movs r4, r0
	movs r5, r1
	movs r6, #1
	and r4, r6
	and r5, r6
	movs r7, r4;
	orr r4, r5
	cmp r4, #0
	beq c1
	cmp r7, #0
	beq c2
	cmp r5, #0
	beq c3
	b c4
rb:
	movs r0, r1
	b r
ra:
	b r
c1:
	lsr r0, #1
	lsr r1, #1
	BL GCD
	movs r4, #2
	mul r0, r4
 	b r
c2:
	lsr r0, #1
	BL GCD
 	b r
c3:
	lsr r1, #1
	BL GCD
	b r
c4:
	cmp r0,r1
	blt lt
	bge ge
lt:
	sub r4, r1, r0
	movs r1, r0
	movs r0, r4
	BL GCD
	b r
ge:
	sub r0, r1
	BL GCD
	b r
r:
	pop {r4}
	sub r2, #4
	movs lr, r4
	BX LR

.global main
main:
	// r0 = m, r1 = n
	ldr r0, =m
	ldr r0, [r0]
	ldr r1, =n
	ldr r1, [r1]
	ldr r2, =0
	ldr r3, =0
	BL GCD
	// get return val and store into result
	ldr r5, =result
	str r0, [r5]
	ldr r2, =max_size
	str r3, [r2]

L: b L
