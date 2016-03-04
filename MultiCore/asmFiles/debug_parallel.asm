#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

#crc
# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------



###################################
### Processor 0
###################################


  org 0x000
  #ori $sp, $0, 0x3FF0 #set stack pointer
  ori $s0, $0, 0    #values generated
  ori $s1, $0, 0    #circular bufferhead
  ori $s2, $0, 0   #current buffer size, max 10
  ori $s3, $0, 10   #max buffer size
  ori $s4, $0, 0    #value generated, max 256
  ori $s5, $0, 0xbeef   #seed
  ori $s6, $0, 40   #buffer head out range
  ori $s7, $0, 256

  
produce:

  lw  $s2, buffersize($0) #load current size
  beq $s2, $s3 ,produce #do nothing is at max size

  beq   $s4, $s7, p0_finish

  ori $a0, $0, lockval
  jal lock #aquire a lock

  lw  $s2, buffersize($0) #load current size
  addiu $s2, $s2, 1 #incremented size
  sw    $s2, buffersize($0) #store incremented size

  #ori $a0, $s5, 0 #use seed as argument
  #jal crc32       #get random number

  #addiu $t0, $s1, buffer      #buffer head true location
  #sw  $v0, 0($t0)            #store value on ring buffer

  #ori   $s5, $v0, 0x0000        #update seed

  #addiu $s1, $s1, 0x0004            #increament head
  #jal resethead

  ori $a0, $0, lockval
  jal unlock #release the lock



  ori $t0, $0, 256 #max values should generate
  addiu $s4, $s4, 1
  ori $t2, $0, 256
  #bne $s4, $t0, produce #keep going if not finished
  beq   $s4, $t0, p0_finish
  j produce

resethead:
  beq $s1, $s6, reset_h
  jr  $ra
reset_h:
  ori $s1, $0, 0
  jr  $ra

p0_finish:
  ori $t5, $0, 256
  sw $t5, finishSignal($0)
  halt







###################################
### Processor 1
###################################  

org 0x200
ori $sp, $0, 0x3FF0 #set stack pointer
ori $s2, $0, 40
ori $s3, $0, 1
ori $s4, $0, 0      #set buffertail
ori $s5, $0, 0xFFFF #local min
ori $s6, $0, 0x0000 #local max
ori $s7, $0, 0x0000 #local sum

consume:

  lw $t3, buffersize($0)          #do nothing while empty
  beq $t3, $0, check_p1_finish

  ori $a0, $0, lockval
  jal lock

  lw $t3, buffersize($0)          #do nothing while empty
  ori  $t0, $0, 1
  subu $t3, $t3, $t0       #decrease size and store
  sw    $t3, buffersize($0)

 #addiu  $t4, $s4, buffer       #true buffer tail location
  #lw    $t1, 0($t4)          #load value from buffer tail
    
  #ori    $a1, $t1, 0        #current value as an argument
  #andi   $a1, $a1, 0xFFFF

  #addiu $s4, $s4, 4         #increament tail 
  #jal   resettail


  #ori   $a0, $s5, 0
  #jal   min                 #find min
  #ori   $s5, $v0, 0

  #ori   $a0, $s6, 0
  #jal   max                 #find max value
  #ori   $s6, $v0, 0

  #addu  $s7, $s7, $a1       #get new sum

  ori $a0, $0, lockval
  jal unlock


  j consume                 #loop again


p1_finish:
  
  #sw  $s5, minval($0)
  #sw  $s6, maxval($0)

  #srl $s7, $s7, 4
  #srl $s7, $s7, 4
  #sw  $s7, avgval($0)

  halt

check_p1_finish:
  lw  $t0, finishSignal($0) #check finish signal from p0
  beq $t0, $0, consume
  j p1_finish

resettail:
  beq $s4, $s2, reset_t
  jr  $ra
reset_t:
  ori $s4, $0, 0
  jr  $ra

 
finishSignal:
  cfw 0x000


# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

lockval:
  cfw   0x0000









# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------



# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------



#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------

#data 
buffer:
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  cfw 0x000
  

buffersize:       
  cfw 0x000




org 0x0800

minval:
  cfw 0xFFFF
maxval:
  cfw 0x0000
avgval:
  cfw 0xFFFF


