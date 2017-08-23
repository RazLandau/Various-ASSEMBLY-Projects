# username: razlandau, ID: 307993907

	
.data
message:		.asciiz "\nThe value is "
newLine:		.asciiz "\n"


.text
main:
	# a0 = x
	li $v0, 5
	syscall
	move $a0, $v0

	# a1 = y
	li $v0, 5
	syscall
	move $a1, $v0

	addi $t3, $t3, 1

	# Call gcd
	jal gcd

	# Print result
	li	$v0, 4
	la	$a0, message
	syscall
	li	$v0, 1
	move $a0, $t0
	syscall
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	# Exit program
	li	$v0, 10
	syscall
	 

gcd:
	addi $sp, $sp, -8 # Make room for 2 params
	sw $s0, 0($sp) # Save s0 on stack
	sw $s1, 4($sp) # Save s1 on stack
	
	move $s0, $a0 # s0 = a0 = x
	move $s1, $a1 # s1 = a1 = y
	
	slt $t0, $s0, $s1	# t0 = 1 iff x < y
	beq $t0 , $zero, gcdLoop # if x >= y continue
	
	swap:	# Swap s0, s1
		move $t0, $s0
		move $s0, $s1
		move $s1, $t0

	gcdLoop: # Main loop. By this point s0 = max{x,y}, s1 = min{x,y}
		beq  $s1, $zero, gcdEnd # Base case: min == 0
		move $t0, $s1 # t0 = min
		rem $s1, $s0, $s1 # min = max%min
		move $s0, $t0 # max = min
		b gcdLoop # Recursive call
	
	gcdEnd: # End of function
		move $v0, $a0 # v0 = gcd(x,y)
		lw $s1, 4($sp) # Restore s1 from stack
		lw $s0, 0($sp) # Restore s0 from stack
		addi $sp, $sp, 8 # Restore stack pointer
		jr $ra
		
	
