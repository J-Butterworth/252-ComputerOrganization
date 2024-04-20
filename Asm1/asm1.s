.data

EQUAL: 		.asciiz "EQUALS"
NEQUAL: 	.asciiz "NOTHING EQUALS"
SPACE: 		.asciiz " "
NEWLINE: 	.asciiz "\n"
ASCENDING:	.asciiz "ASCENDING"
DESCENDING:	.asciiz "DESCENDING"
AEQUAL:		.asciiz "ALL EQUAL"
UNORDERED:	.asciiz "UNORDERED"
REVERSE:	.asciiz "REVERSE"
RED:		.asciiz "red: "
ORANGE:		.asciiz "orange: "
YELLOW:		.asciiz "yellow: "
GREEN:		.asciiz "green: "
BLUE:		.asciiz "blue: "
PURPLE:		.asciiz "purple: "

.text

.globl studentMain

studentMain:
    	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    
# Loading all variables.	
    	la $s0, equals			# s0=&equals
    	lw $s0, 0($s0)			# s0=equals
    	
    	la $s1, order			# s1=&order
    	lw $s1, 0($s1)			# s1=order
    	
    	la $s2, reverse			# s2=&reverse
    	lw $s2, 0($s2)			# s2=reverse
    	
    	la $s3, print			# s3=&print
    	lw $s3, 0($s3)			# s3=print
    	

	la $t0, red 			# t0=&red
	lw $t0, 0($t0)			# t0=red
	
	la $t1, orange 			# t1=&orange
	lw $t1, 0($t1)			# t1=orange
	
	la $t2, yellow 			# t2=&yellow
	lw $t2, 0($t2)			# t2=yellow
	
	la $t3, green 			# t3=&green
	lw $t3, 0($t3)			# t3=green
	
	la $t4, blue 			# t4=&blue
	lw $t4, 0($t4)			# t4=blue
	
	la $t5, purple 			# t5=&purple
	lw $t5, 0($t5)			# t5=purple
	
	
# Task 1: Checking for equal pair.
TASK_1:
	beq $zero, $s0, TASK_2		# Skip task 1, go to task 2 (order)
	
	beq $t0, $t1, ELSE		# Go to print EQUALS if $t0==$t1
	beq $t0, $t2, ELSE		# Go to print EQUALS if $t0==$t2
	beq $t0, $t3, ELSE		# Go to print EQUALS if $t0==$t3
	beq $t1, $t2, ELSE		# Go to print EQUALS if $t1==$t2
	beq $t1, $t3, ELSE		# Go to print EQUALS if $t1==$t3
	beq $t2, $t3, ELSE		# Go to print EQUALS if $t2==$t3
	
	addi $v0, $zero, 4		#Print "NOTHING EQUALS" string since we did not find matching pair.
	la $a0, NEQUAL
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall
	
	j TASK_2
	
	
	ELSE:
	addi $v0, $zero, 4		#Print "EQUALS" string.
	la $a0, EQUAL
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall
	
	j TASK_2
	
# Task 2: Checking ascending or descending.
TASK_2:
	beq $zero, $s1, TASK_3		# Skip task 2, go to task 3 (reverse)
	
	ALL_EQUAL:
	bne $t0, $t1, ASCEND_CHECK	#If t0!=t1, go to check if they are ascending.
	bne $t0, $t2, ASCEND_CHECK	#If t0!=t2, go to check if they are ascending.
	bne $t0, $t3, ASCEND_CHECK	#If t0!=t3, go to check if they are ascending.
	bne $t0, $t4, ASCEND_CHECK	#If t0!=t4, go to check if they are ascending.
	bne $t0, $t5, ASCEND_CHECK	#If t0!=t5, go to check if they are ascending. 
	bne $t1, $t2, ASCEND_CHECK	#If t1!=t2, go to check if they are ascending.
	bne $t1, $t3, ASCEND_CHECK	#If t1!=t3, go to check if they are ascending.
	bne $t1, $t4, ASCEND_CHECK	#If t1!=t4, go to check if they are ascending.
	bne $t1, $t5, ASCEND_CHECK	#If t1!=t5, go to check if they are ascending.
	bne $t2, $t3, ASCEND_CHECK	#If t2!=t3, go to check if they are ascending.
	bne $t2, $t4, ASCEND_CHECK	#If t2!=t4, go to check if they are ascending.
	bne $t2, $t5, ASCEND_CHECK	#If t2!=t5, go to check if they are ascending.
	bne $t3, $t4, ASCEND_CHECK	#If t3!=t4, go to check if they are ascending.
	bne $t3, $t5, ASCEND_CHECK	#If t3!=t5, go to check if they are ascending.
	
	addi $v0, $zero, 4		#Print "ALL EQUAL" string since we know all values are equal.
	la $a0, AEQUAL
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall
	
	j TASK_3				# Jump to task 3.
	
	ASCEND_CHECK:
	slt $t6, $t1, $t0		# t6 = t1<t0.
	bne $zero, $t6, DESCEND_CHECK	# If t0>t1, go check if values are descending instead.
	slt $t6, $t2, $t1		# t6 = t2<t1.
	bne $zero, $t6, DESCEND_CHECK	# If t1>t2, go check if values are descending instead.
	slt $t6, $t3, $t2		# t6 = t3<t2.
	bne $zero, $t6, DESCEND_CHECK	# If t2>t3, go check if values are descending instead.
	slt $t6, $t4, $t3		# t6 = t4<t3.
	bne $zero, $t6, DESCEND_CHECK	# If t3>t4, go check if values are descending instead.
	slt $t6, $t5, $t4		# t6 = t5<t4.
	bne $zero, $t6, DESCEND_CHECK	# If t4>t5, go check if values are descending instead.
	
	addi $v0, $zero, 4		#Print "ASCENDING" string since we know all values are ascending.
	la $a0, ASCENDING
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall
	
	j TASK_3			# Jump to task 3.
	
	DESCEND_CHECK:
	slt $t6, $t0, $t1		# t6 = t0<t1.
	bne $zero, $t6, NO_ORDER	# If t0<t1, values are unordered since we know they are not ascending.
	slt $t6, $t1, $t2		# t6 = t1<t2.
	bne $zero, $t6, NO_ORDER	# If t1<t2, values are unordered since we know they are not ascending.
	slt $t6, $t2, $t3		# t6 = t2<t3.
	bne $zero, $t6, NO_ORDER	# If t2<t3, values are unordered since we know they are not ascending.
	slt $t6, $t3, $t4		# t6 = t3<t4.
	bne $zero, $t6, NO_ORDER	# If t3<t4, values are unordered since we know they are not ascending.
	slt $t6, $t4, $t5		# t6 = t4<t5.
	bne $zero, $t6, NO_ORDER	# If t4<t5, values are unordered since we know they are not ascending.
	
	addi $v0, $zero, 4		#Print "DESCENDING" string since we know all values are descending.
	la $a0, DESCENDING
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall
	
	j TASK_3			# Jump to task 3.
	

	NO_ORDER:			# Will only reach this line if values are unordered.
	addi $v0, $zero, 4		# Print "UNORDERED" string.
	la $a0, UNORDERED
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall
	
	
	
# Task 3: Writing six values back to memory in reverse.
TASK_3:
	beq $zero, $s2, TASK_4		# Skip task 3, go to task 4 (print)
	
	add $t6, $zero, $t0		# t6==t0.
	add $t0, $zero, $t5		# t0==t5.
	add $t5, $zero, $t6		# t5==t6.
	add $t6, $zero, $t1		# t6==t1.
	add $t1, $zero, $t4		# t1==t4.
	add $t4, $zero, $t6		# t4==t6.
	add $t6, $zero, $t2		# t6==t2.
	add $t2, $zero, $t3		# t2==t3.
	add $t3, $zero, $t6		# t3==t6.
	
	la $t6, red			# Rewrite red value in storage.
	sw $t0, 0($t6)			
	la $t6, orange			# Rewrite orange value in storage.
	sw $t1, 0($t6)		
	la $t6, yellow			# Rewrite yellow value in storage.
	sw $t2, 0($t6)
	la $t6, green			# Rewrite green value in storage.
	sw $t3, 0($t6)
	la $t6, blue			# Rewrite blue value in storage.
	sw $t4, 0($t6)
	la $t6, purple			# Rewrite purple value in storage.
	sw $t5, 0($t6)
	
	
	
	addi $v0, $zero, 4		# Print "REVERSE" string.
	la $a0, REVERSE
	syscall
	
	addi $v0, $zero, 4		# Print new line before next task.
	la $a0, NEWLINE
	syscall

# Task 4: Print out the four values.
TASK_4:
	beq $zero, $s3, DONE		# Skip task 4, go to DONE
	
	addi $v0, $zero, 4		# Print "red: " string.
	la $a0, RED
	syscall
	addi $v0, $zero, 1		# Print the value of red.
	add $a0, $zero, $t0
	syscall
	addi $v0, $zero, 4		# Print new line before next value.
	la $a0, NEWLINE
	syscall
	
	addi $v0, $zero, 4		# Print "orange: " string.
	la $a0, ORANGE
	syscall
	addi $v0, $zero, 1		# Print the value of orange.
	add $a0, $zero, $t1
	syscall
	addi $v0, $zero, 4		# Print new line before next value.
	la $a0, NEWLINE
	syscall
	
	addi $v0, $zero, 4		# Print "yellow: " string.
	la $a0, YELLOW
	syscall
	addi $v0, $zero, 1		# Print the value of yellow.
	add $a0, $zero, $t2
	syscall
	addi $v0, $zero, 4		# Print new line before next value.
	la $a0, NEWLINE
	syscall
	
	addi $v0, $zero, 4		# Print "green: " string.
	la $a0, GREEN
	syscall
	addi $v0, $zero, 1		# Print the value of green.
	add $a0, $zero, $t3
	syscall
	addi $v0, $zero, 4		# Print new line before next value.
	la $a0, NEWLINE
	syscall
	
	addi $v0, $zero, 4		# Print "blue: " string.
	la $a0, BLUE
	syscall
	addi $v0, $zero, 1		# Print the value of blue.
	add $a0, $zero, $t4
	syscall
	addi $v0, $zero, 4		# Print new line before next value.
	la $a0, NEWLINE
	syscall
	
	addi $v0, $zero, 4		# Print "purple: " string.
	la $a0, PURPLE
	syscall
	addi $v0, $zero, 1		# Print the value of purple.
	add $a0, $zero, $t5
	syscall
	addi $v0, $zero, 4		# Print new line before next value.
	la $a0, NEWLINE
	syscall
	
	
DONE:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code




