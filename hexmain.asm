  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text

	
main:
	li	$a0,5		# change this to test different values
	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register
	li	$v0,11		# syscall with v0 = 11 will print out
	syscall	
			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  hexasc:
  	li $t0, 15
  	and $t1, $a0, $t0 #mask 4 LSb from a0
  #is last 4 0-9
 	li $t2, 10
 	slt $t3, $t1, $t2
 	bne $t3, 1, is_letter #if 3 is not less than 9--> letter
 	addi $t1, $t1, 48
 	j end_hexa
 
 
 is_letter:
 	addi $t1, $t1, 55
 
 end_hexa: 
 	move $v0, $t1
 	jr $ra
 	nop
 
