#--------------------------------------
# Test branch and jumps
#--------------------------------------
  org 0x0000
  ori   $15, $zero, jmpR
  ori   $1, $zero, 0x30
  ori   $2, $zero, 0x64
  sltu   $4,$2,$1
  beq   $4, $zero, braZ
  sw    $1, 0($2)
braZ:
  jal   braR
  sw    $1, 4($2)
end:
  sw    $ra, 16($2)
  HALT
braR:
  or    $3, $zero, $ra
  sw    $ra, 8($2)
  #jal   jmpR
  jr	$31
  sw    $1, 12($2)
jmpR:
  bne   $ra, $3, end
  halt
