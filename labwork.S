  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
.data

  #
  # Please add your own code below this line
  #
  .text
  .globl time2string
  time2string:
 	PUSH	$ra
 	PUSH	$s0
 	PUSH	$s1
 	
 	move $s0,$a0
 	move $s1,$a1
 	
 	andi $a0, $s1,0xF000
 	srl $a0,$a0,12
 	jal hexasc
 	nop
 	sb $v0, 0($s0)
 	
 	
 	
 	andi $a0, $s1,0xF00
 	srl $a0,$a0,8
 	jal hexasc
 	nop
 	sb $v0, 1($s0)
 	nop
 	
 	addi $v0, $0, 0x3a
 	sb $v0, 2($s0)
 	nop
 	
 	andi $a0, $s1,0xF0
 	srl $a0,$a0,4
 	jal hexasc
 	nop
 	sb $v0, 3($s0)
 	nop
 	

 	andi $a0, $s1,0xF
 	jal hexasc
 	nop
 	sb $v0, 4($s0)
 	nop
 	
 	addi $v0, $0,0x00
 	sb $v0, 5($s0)

 	
 	addi $v0, $0,0x00
 	sb $v0, 6($s0)
 	j stopp
 	nop
 	
 stopp:
 	POP $s1
 	POP $s0
 	POP $ra
 	
 	jr $ra
 	nop
  
  .globl hexasc
  hexasc:
  	li $t0, 15
  	and $t1, $a0, $t0 #mask 4 LSb from a0
  #is last 4 0-9
 	li $t2, 10
 	slt $t3, $t1, $t2
 	bne $t3, 1, is_letter #if 3 is not less than 9--> letter
 	addi $t1, $t1, 48
 	j end_hexa
 	nop
 
 
 is_letter:
 	addi $t1, $t1, 55
 
 end_hexa: 
 	move $v0, $t1
 	jr $ra
 	nop
 

.globl delay
delay: 
	
	PUSH	$ra
	PUSH	$s0
	move $s0, $a0
	
while_loop:
	slt $t1, $0, $s0 #if ms>0
	bne $t1, 1, exit 
	addi $s0, $s0,-1 #ms--
	
	li $t0, 0 #i=0
for_loop:	
	li $t2, 3090
	slt $t3, $t0, $t2 #for i<4771
	bne $t3, 1, while_loop #if i>4771 gå tbs till while
	addi $t0, $t0, 1 #annars i++
	j for_loop
	nop
	
exit:
	POP	$s0
	POP	$ra
	jr $ra
	nop
.global enable_interrupts
enable_interrupts:
    ei
    jr  $ra
    nop
	
