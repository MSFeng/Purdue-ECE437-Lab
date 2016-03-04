org   0x0000
  ori   $1, $zero, 0xF0
  ori   $2, $zero, 0x100
  addi  $3, $2, 0x200
  subu  $4, $3, $2
  lw    $5,0($1)
  lw    $6,0($1)
  addu  $5, $5, $6
  #addu  $6, $6, $2
  #lw    $6,0($1)
  sw    $5, 16($1)
 
  halt      # that's all

  org   0x00F0
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
