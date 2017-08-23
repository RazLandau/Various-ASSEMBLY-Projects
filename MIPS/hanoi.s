# username: razlandau, ID: 307993907

.data
A: .asciiz "A"
B: .asciiz "B"
C: .asciiz "C"
to: .asciiz ">"
newLine: .asciiz "\n"


.text
main:
	# a0 = number of discs = n
	li	$v0, 5
	syscall
	move $a0, $v0
	
	# call hanoi
	jal hanoi
	
	# Exit program
	li $v0, 10
	syscall


hanoi :
	addi $sp, $sp, -4 # make room on stack for 1 params
	sw $ra, 0($sp) # save ra on stack
	
	la $a1, A # a1 = start
	la $a2, B # a2 = auxiliary
	la $a3, C # a3 = end
	jal solve # call helper function
	
	lw $ra, 0($sp) # restore ra from stack	
	addi $sp, $sp, -4 # restore stack pointer
	jr $ra
	
solve:
	addi $sp, $sp, -20 # make room on stack for 5 params
	sw $ra, 16($sp) # save ra on stack
	sw $a0, 12($sp) # save a0 on stack
	sw $a1, 8($sp) # save a1 on stack
	sw $a2, 4($sp) # save a2 on stack
	sw $a3, 0($sp) # save a3 on stack
	
	baseCase: # a0 = number of discs = 1
		bne $a0, 1, firstRecursive
		jal print
		b gcdEnd
	
	firstRecursive: # solve(n - 1, start, end, auxiliary)
		addi $a0, $a0, -1 # n = n-1
		# swap(auxiliary, end)
		move $t0, $a2 # save auxiliary
		move $a2, $a3 # auxiliary = end
		move $a3, $t0 # end = auxiliary
		jal solve # recursive call
		addi $a0, $a0, 1 # restore n
		# swap(auxiliary, end)
		move $t0, $a2 # save auxiliary
		move $a2, $a3 # auxiliary = end
		move $a3, $t0 # end = auxiliary		
	
	# System.out.println(start + " > " + end);
	jal print
	 
	secondRecursive: # solve(n - 1, auxiliary, start, end);
		addi $a0, $a0, -1 # n = n-1
		# swap(start, auxiliary)
		move $t0, $a1 # save start
		move $a1, $a2 # start = auxiliary
		move $a2, $t0 # auxiliary = start
		jal solve
		addi $a0, $a0, 1 # restore n
		# swap(start, auxiliary)
		move $t0, $a1 # save start
		move $a1, $a2 # start = auxiliary
		move $a2, $t0 # auxiliary = start
	
	gcdEnd:
		lw $a3, 0($sp) # restore $a3 from stack		
		lw $a2, 4($sp) # restore $a2 from stack			
		lw $a1, 8($sp) # restore $a1 from stack			
		lw $a0, 12($sp) # restore $a0 from stack		
		lw $ra, 16($sp) # restore $ra from stack
		addi $sp, $sp, 20 # restore stack pointer	
		jr $ra
	
		
print: # System.out.println(a1 + " > " + a3);
	addi $sp, $sp, -4 # make room for 1 param on stack
	sw $a0, 0($sp) # store a0 on stack
	
	# print from
	move $a0, $a1
	li $v0, 4
	syscall
	
	# print ">"
	li $v0, 4
	la $a0, to
   	syscall
   	
   	# print to
	li $v0, 4
	move $a0, $a3
	syscall
	
	# print "\n"
	li $v0, 4
	la $a0, newLine
	syscall
	
	lw $a0, 0($sp) # restore $ra from stack
	addi $sp, $sp, 4 # restore stack pointer	
	jr $ra
	
