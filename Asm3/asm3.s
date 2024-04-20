.data

BOTTLE1: 	.asciiz " bottles of "
BOTTLE2: 	.asciiz " on the wall, "
BOTTLE3: 	.asciiz "!\n"
BOTTLE4: 	.asciiz "Take one down, pass it around, "
BOTTLE5: 	.asciiz " on the wall.\n"
BOTTLE6: 	.asciiz "No more bottles of "
BOTTLE7: 	.asciiz " on the wall!\n"
SPACE: 		.asciiz " "
NEWLINE: 	.asciiz "\n"

.text

.globl studentMain

studentMain:
    	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer

TASK_1:

.globl strlen
	
strlen:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	addiu $fp, $sp, 20		# setup main’s frame pointer
	
	add $t0, $zero, $zero		# t0 will keep track of word's character count.
strlen_LOOP:
	lb   $t1, 0($a0)			# Get string's first byte.
	beq  $t1, $zero, strlen_DONE	# If we are at end of word, function is over.
	addi $a0, $a0, 1		# Shift to the next available char in string.
	addi $t0, $t0, 1		# count++
	j strlen_LOOP			# Return to beginning of loop to check next char.
strlen_DONE:
	add   $v0, $zero, $t0		# Set the function value = character count.
	
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	
TASK_2:

.globl gcf
gcf:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	addiu $fp, $sp, 20		# setup main’s frame pointer
	
	slt $t0, $a0, $a1		# t0 = (a<b)
	bne $t0, $zero, SWAP		# If a<b, jump to swap them.
	beq $t0, $zero, GCF_CONTINUE	# If a<b is false, we can skip swapping them.
	
SWAP:
	add $t0, $zero, $a0		# t0 = a.
	add $a0, $zero, $a1		# a = b.
	add $a1, $zero, $t0		# b = a.
	
	
GCF_CONTINUE:
	addi $t0, $zero, 1		# t0 = 1
	beq  $a1, $t0, GET_1		# If b == 1, then return 1.
	div  $a0, $a1			# lo = (a/b).
					# hi = (a%b).
	mfhi $t0			# t0 = a%b.
	beq  $t0, $zero, GET_B		# If (a%b) == 0, then return b.
	j UPDATE_GCF			# If we have gotten this far, update function parameters.
GET_1:
	addi $v0, $zero, 1		# $v0 = 1.
	j GCF_DONE			# Skip to prologue.
GET_B:
	add $v0, $zero, $a1		# $v0 = b.
	j GCF_DONE			# Skip to prologue.
UPDATE_GCF:
	add $a0, $zero, $a1		# a = b.
	add $a1, $zero, $t0		# b = (a%b). ASK ABOUT RESET.
	jal gcf
	
GCF_DONE:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	
TASK_3:

.globl bottles
bottles:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
    	add $t2, $zero, $a0		# t2 = count.
    	
BOTTLE_LOOP:
	slt $t0, $zero, $t2		# t0 = 0<count.
	beq $t0, $zero, BOTTLE_DONE	# If 0<i is false, end loop.
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t2		
	syscall				# Print count integer at %d.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE1
	syscall				# Print " bottles of "
	
	addi $v0, $zero, 4
	add  $a0, $zero, $a1
	syscall				# Print thing string at %s.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE2
	syscall				# Print " on the wall, "
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t2
	syscall				# Print count integer at %d.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE1
	syscall				# Print " bottles of "
	
	addi $v0, $zero, 4
	add  $a0, $zero, $a1
	syscall				# Print thing string at %s.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE3
	syscall				# Print "!\n"
	
	addi $t3, $t2, -1		# t3 = count - 1
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE4
	syscall				# Print "Take one down, pass it around, "
	
	addi $v0, $zero, 1
	add $a0, $zero, $t3
	syscall				# Print count - 1 at %d.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE1
	syscall				# Print " bottles of "
	
	addi $v0, $zero, 4
	add  $a0, $zero, $a1
	syscall				# Print thing string at %s.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE5
	syscall				# Print " on the wall.\n"
	
	addi $v0, $zero, 4
	la   $a0, NEWLINE
	syscall				# Print newline.
	
	addi $t2, $t2, -1		# count--.
	j BOTTLE_LOOP			# loop and repeat if count>0 still.
    	
BOTTLE_DONE:
	# Display final print statements.
	addi $v0, $zero, 4
	la   $a0, BOTTLE6
	syscall				# Print "No more bottles of ".
	
	addi $v0, $zero, 4
	add  $a0, $zero, $a1
	syscall				# Print thing string at %s.
	
	addi $v0, $zero, 4
	la   $a0, BOTTLE7
	syscall				# Print " on the wall!\n".
	
    	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code

TASK_4:

.globl longestSorted
longestSorted:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
	beq $a1, $zero, SORT_RETURN_0	# If array length == 0, jump to return 0.
	
	addi $t0, $zero, 1		# t0 = current_count (1)
	addi $t1, $zero, 1		# t1 = best_count (1)
	add  $t5, $zero, $zero		# t5 = i = 0.
	addi $t6, $a1, -1		# t6 = array_length-1.
	
SORT_LOOP:
	slt $t7, $t5, $t6		# t7 = (i<array_length-1).
	beq $t7, $zero, SORT_RETURN	# If t7 is false, then we end the loop.
	
	lw $t2, 0($a0)			# t2 = array[i]
	
	lw  $t3, 4($a0)			# t3 = array[i+1]
	slt $t4, $t3, $t2		# t4 = (t2>t3)
	beq $t4, $zero, SORT_ADDCOUNT 	# If !t4, (t3>=t2), add to count.
	
	# Update best_count with current_count if necessary.
	slt  $t4, $t1, $t0		# t4 = best_count<current_count.
	beq  $t4, $zero, SORT_CONTINUE	# If this is false, do not update.
	add  $t1, $zero, $t0		# t1 = best_count = current_count.
	addi $t0, $zero, 1		# Reset current_count.
	
SORT_CONTINUE:
	addi $a0, $a0, 4		# Update current element in array.
	beq  $a0, $zero, SORT_RETURN	# If reached end of array, then exit.
	addi $t5, $t5, 1		# i++.
	j SORT_LOOP			# If not, iterate thorugh loop again.
	
SORT_ADDCOUNT:
	addi $a0, $a0, 4		# Update current element in array.
	beq  $a0, $zero, SORT_RETURN	# If reached end of array, then exit.
	addi $t5, $t5, 1		# i++.
	addi $t0, $t0, 1		# current_count++
	j SORT_LOOP			# Iterate back through loop.

SORT_RETURN:
	# Update best_count with current_count if necessary.
	slt $t4, $t1, $t0		# t4 = best_count<current_count.
	beq $t4, $zero, CONTINUE_RETURN	# If this is false, do not update.
	add $t1, $zero, $t0		# t1 = best_count = current_count.
	
CONTINUE_RETURN:
	add $v0, $zero, $t1		# Set v0 = best_count.
	j SORT_DONE			
	
SORT_RETURN_0:
	add $v0, $zero, $zero		# Set function's value to 0.
	j SORT_DONE			# Jump to epilogue.
		
SORT_DONE:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	
TASK_5:

.globl rotate
rotate:
	addiu $sp, $sp, -36		# allocate stack space -- default of 36 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 32 		# setup main’s frame pointer
    	
    	# Aloocate extra space in the stack for all sX registers.
    	addiu $sp, $sp, -32
    	sw    $s0, 0($sp)
    	sw    $s1, 4($sp)
    	sw    $s2, 8($sp)
    	sw    $s3, 12($sp)
    	sw    $s4, 16($sp)
    	sw    $s5, 20($sp)
    	sw    $s6, 24($sp)
    	sw    $s7, 28($sp)
    	
    	# Put all seven parameters into sX registers.
    	# Leave aX registers empty in the stack.
    	add $s0, $zero, $a0		# s0 = count.
    	add $s1, $zero, $a1		# s1 = a.
    	add $s2, $zero, $a2		# s2 = b.
    	add $s3, $zero, $a3		# s3 = c.
    	lw  $s4, 56($sp)			# s4 = d. #56
    	lw  $s5, 60($sp)			# s5 = e. #60
    	lw  $s6, 64($sp)			# s6 = f. #64
    	
    	add $s7, $zero, $zero		# s7 = retval = 0.
    	
    	sw  $s0, -24($fp)
    	add $s0, $zero, $zero		# s0 = i = 0
    	
 ROTATE_LOOP:
 	lw  $t1, -24($fp)		# t1 = count.
	slt $t2, $s0, $t1		# t2 = (i<count).
	beq $t2, $zero, ROTATE_DONE	# If (i<count) is false, exit loop.
	
	# Set the aX registers for the jal util call.
	add $a0, $zero, $s1		# a0 = a
	add $a1, $zero, $s2		# a1 = b
	add $a2, $zero, $s3		# a2 = c
	add $a3, $zero, $s4		# a3 = d
	sw  $s5, -8($sp)			# Add e to main stack for util call.
	sw  $s6, -4($sp)			# Add f to main stack for util call.
	
	jal util			# Get v0 output from calling util.
	add $s7, $s7, $v0		# Retval += util(.....).
	
	add $t3, $zero, $s1		# t3 = temp = a.
	add $s1, $zero, $s2		# a = b.
	add $s2, $zero, $s3		# b = c.
	add $s3, $zero, $s4		# c = d.
	add $s4, $zero, $s5		# d = e.
	add $s5, $zero, $s6		# e = f.
	add $s6, $zero, $t3		# f = temp = a.
	
	addi $s0, $s0, 1		# i++
	j ROTATE_LOOP			# Iterate over loop again.
	    	
  ROTATE_DONE:
  	add $v0, $zero, $s7		# Save retVal to t0 before resetting sX registers.
  	
  	# Reset all registers by getting originals from stack.
  	lw $s0, 0($sp)
    	lw $s1, 4($sp)
    	lw $s2, 8($sp)
    	lw $s3, 12($sp)
    	lw $s4, 16($sp)
    	lw $s5, 20($sp)
    	lw $s6, 24($sp)
    	lw $s7, 28($sp)
    	
    	addiu $sp, $sp, 32		# Deallocating extra stack space.
  	
  	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 36 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code

DONE:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
