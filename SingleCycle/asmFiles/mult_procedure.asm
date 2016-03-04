org 0x0000

main:

ori $29, $0, 0xfffc #initialize stack pointer
ori $1, $0, 0x0002 #first oprand
ori $2, $0, 0x0002 #second oprand
ori $3, $0, 0x0003 #third oprand
ori $4, $0, 0x0002 #third oprand 
ori $8, $0, 0xfff8 #set check num to check stack size

ori   $21,$zero,0x80
ori   $22,$zero,0xF0

push $1
push $2
push $3
push $4

procedure:
	beq $29, $8, finish
	jal mult 
	j procedure
	

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
	pop $1
	sw  $1, 0($21)
halt
