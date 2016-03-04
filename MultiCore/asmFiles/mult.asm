org 0x0000

ori $29, $0, 0xfffc #initialize stack pointer
ori $1, $0, 0x0005 #first oprand
ori $2, $0, 0x0002 #second oprand

ori   $21,$zero,0x80
ori   $22,$zero,0xF0

push $1
push $2


mult:
	ori $1, $0, 0x0001 #store 1 for substraction use
	ori $4, $0, 0x0000 #initialize $5 to 0 for result
	pop $2		
	pop $3	
	
mult_loop:
	beq $3, $0, finish  #jump out if 2nd oprand reaches 0		
	addu $4, $4, $2
	subu $3, $3, $1
	j mult_loop
	

finish:
	push $4
	ori $1, $4, 0x0000 
	sw  $1, 0($21)
halt
