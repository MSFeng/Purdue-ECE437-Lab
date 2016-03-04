org 0x0000

main:

ori $29, $0, 0xfffc #initialize stack pointer
ori $5, $0, 0x0008 #Current day
ori $6, $0, 0x000b #Current Month
ori $7, $0, 0x07df #Current Year

ori   $21,$zero,0x80
ori   $22,$zero,0xF0

calc:
	ori $8, $0, 0x0001 #temp value
	subu $6, $6, $8  #CurrentMonth-1
	ori $8, $0, 0x07d0
	subu $7, $7, $8  #CurrentYear-2000

	ori $8, $0, 0x001e #set 30
	push $8
	push $6
	jal mult
	pop $6 #(CurrentMonth-1)*30

	ori $8, $0, 0x016d
	push $8
	push $7
	jal mult
	pop $7
	
	addu $8, $5, $6
	addu $8, $8, $7 

	j finish
mult:
	ori $1, $0, 0x0001 #store 1 for substraction use
	ori $4, $0, 0x0000 #initialize $5 to 0 for result
	pop $2		
	pop $3		
	
mult_loop:
	beq $3, $0, mult_loop_done  #jump out if 2nd oprand reaches 0		
	addu $4, $4, $2
	subu $3, $3, $1
	j mult_loop
mult_loop_done:
	push $4
	jr $31
	

finish:
	ori $1, $8, 0x0000 #move result to r1
	sw  $1, 0($21)

	halt
