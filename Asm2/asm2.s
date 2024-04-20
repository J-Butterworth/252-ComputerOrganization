.data

SPACE: 		.asciiz " "
NEWLINE: 	.asciiz "\n"
FIBNUMBERS:	.asciiz "Fibonacci Numbers:\n"
ZEROCHUNK:	.asciiz "  0: 1\n"
ONECHUNK:	.asciiz "  1: 1\n"
COLONSPACE:	.asciiz ": "
ASCENDING:	.asciiz "Run Check: ASCENDING\n"
DESCENDING:	.asciiz "Run Check: DESCENDING\n"
NEITHER:	.asciiz "Run Check: NEITHER\n"
WORDCOUNT:	.asciiz "Word Count: "
SWAPPED: 	.asciiz "String successfully swapped!\n"
REVERSE:	.asciiz "REVERSE"

.text

.globl studentMain




studentMain:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
    	addiu $sp, $sp, -8
    	
    	sw $s0, 0($sp)
    	sw $s1, 4($sp)
    	
    	
    	# Assign control variables to the sX registers.
    	la $s0, fib			# s0 = &fib.
    	lw $s0, 0($s0)			# s0 = fib.
    	la $s1, square			# s1 = &square.
    	lw $s1, 0($s1)			# s1 = square.
    	la $s2, runCheck		# s2 = &runCheck.
    	lw $s2, 0($s2)			# s2 = runCheck.
    	la $s3, countWords		# s3 = &countWords.
    	lw $s3, 0($s3)			# s3 = countWords.
    	la $s4, revString		# s4 = &revString.
    	lw $s4, 0($s4)			# s4 = revString.
    	
### NEW TASK ###
	beq  $s0, $zero, FIB_DONE	# If fib == 0, skip task.
   FIBONACCI:
	addi $t2, $zero, 1		# t2 = (beforeThat=1)
	
	addi $t3, $zero, 1		# t3 = (prev=1)
	
	addi $t4, $zero, 2		# t4 = (n==2). Add 1 for each iteration.

	addi $v0, $zero, 4		# Print "Fibonacci Numbers:\N".
	la   $a0, FIBNUMBERS
	syscall
	
	addi $v0, $zero, 4		# Print zero line and space
	la   $a0, ZEROCHUNK
	syscall
	
	addi $v0, $zero, 4		# Print one line and space
	la   $a0, ONECHUNK
	syscall
LOOP:
	slt $t5, $s0, $t4		# t5 = fib < n
	bne $t5, $zero, FINAL_PRINT	# If t5 is true, loop is done.
	
	addi $v0, $zero, 4		# Print a space.
	la   $a0, SPACE
	syscall
	
	addi $v0, $zero, 4		# Print a space.
	la $a0, SPACE
	syscall
	
	add $t5, $t2, $t3		# t5 = (curr = prev+beforeThat)
	
	addi $v0, $zero, 1		# Print value of n.
	add  $a0, $zero, $t4
	syscall
	
	addi $v0, $zero, 4		# Print colon and space
	la   $a0, COLONSPACE
	syscall
	
	addi $v0, $zero, 1		# Print value of curr.
	add  $a0, $zero, $t5
	syscall
	
	addi $v0, $zero, 4		# Print new line before next iteration.
	la   $a0, NEWLINE
	syscall
	
	addi $t4, $t4, 1		# n++
	add  $t2, $zero, $t3		# beforeThat = prev
	add  $t3, $zero, $t5		# prev = curr
	j LOOP
	
FINAL_PRINT:
	addi $v0, $zero, 4		# Print new line before next task.
	la   $a0, NEWLINE
	syscall
	
FIB_DONE:


### NEW TASK ###

	beq $s1, $zero, SQUARE_DONE	# If square == 0, skip task.
	
SQUARE:
	add $t0, $zero, $zero		# t0 = (row==0)
	
	la  $t2, square_size		# t2 = &square_size.
	lw  $t2, 0($t2)			# t2 = square_size.
	
	addi $t4, $t2, -1		# t4 = square_size-1
OUTERFOR:
	slt  $t3, $t0, $t2		# t3 = (row < square_size)
	beq  $t3, $zero, FINAL_SPACE	# If this ^ is false, end loop.
	
	beq $t0, $zero, GO_IN		# If row==0, go in.
	beq $t0, $t4, GO_IN		# If row==square_size-1, go in.
	j ELSE				# Otherwise, jump to else.
	
GO_IN:
	addi $t5, $zero, '+'		# t5 = (lr = '+')
	addi $t6, $zero, '-'		# t6 = (mid = '-')
	j NEXT				# Skip else, continute for loop.
ELSE:
	addi $t5, $zero, '|'		# t5 = (lr = '|')
	la   $t6, square_fill		# t6 = &square_fill.
	lb   $t6, 0($t6)			# t6 = square_fill.
	j NEXT				# Continue with for loop.

NEXT:
	addi $v0, $zero, 11		# Print lr character.
	add  $a0, $zero, $t5
	syscall
	
	addi $t1, $zero, 1		# t1 = (i==1)
INNERFOR:
	slt $t7, $t1, $t4 		# t7 = (i < square_size - 1)
	beq $t7, $zero, CONTINUE	# If this is false, end inner loop.
	
	addi $v0, $zero, 11		# Print mid character.
	add  $a0, $zero, $t6
	syscall
	
	addi $t1, $t1, 1		# i++
	j INNERFOR			# Repeat inner loop.
CONTINUE:
	addi $v0, $zero, 11		# Print lr character.
	add  $a0, $zero, $t5
	syscall
	
	addi $v0, $zero, 4		# Print new line.
	la   $a0, NEWLINE
	syscall
	
	addi $t0, $t0, 1		# row++
	j OUTERFOR

FINAL_SPACE:
	addi $v0, $zero, 4		# Print new line before TASK_3.
	la   $a0, NEWLINE
	syscall
	
SQUARE_DONE:
    	
### NEW TASK ###	
    	  
   	# Check if runCheck == 1.
	addi $t0, $zero, 1
	bne  $s2, $t0, RUN_DONE	# If runCheck != 1, skip task.
RUN_CHECK:
	la $t6, intArray		# t6 = &intArray.
	
	la $t7, intArray_len		# t7 = &intArray_len.
	lw $t7, 0($t7)			# t7 = intArray_len.
	
	beq  $t7, $zero, BOTH		# If arrayLen = 0, print both.
	addi $t2, $zero, 1		# t2 = 1.
	beq  $t7, $t2, BOTH		# If arrayLen = 1, print both.
	
	# s5 will serve as a marker for whether we have printed ascending.
	# Will be used when checking if NEITHER is true later on.
	add $s5, $zero, $zero		# s5 = 0.
	

	addi $t0, $zero, 1		# t0 = (i=1).
	
	addi $t7, $t7, -1		# t7 = arrayLen - 1.
	
ASCEND_CHECK:
	slt $t1, $t7, $t0		# t1 = (arrayLen - 1) < i.
	bne $t1, $zero, PRINT_ASCEND	# If this ^ is true, we know list is ascending.
	
	addi $t1, $t0, -1		# t1 = i - 1. (previous value).
	sll  $t1, $t1, 2		# t1 = t1 * 4 (index of previous val).
	add  $t1, $t6, $t1		# t1 = pointer to [i-1]
	lw   $t1, 0($t1)		# t1 = intArray[i-1].
	
	add $t2, $zero, $t0		# t2 = i
	sll $t2, $t2, 2			# t2 = i * 4.
	add $t2, $t6, $t2		# Pointer to i idx.
	lw  $t2, 0($t2)			# t2 = intArray[i].
	
	beq $t1, $t2, ASCEND_UPDATE	# If intArray[i-1] = intArray[i], reiterate through loop.
	slt $t3, $t2, $t1		# t3 = intArray[i] < intArray[i-1].
	bne $t3, $zero, START_DESCEND	# If this ^ is true, list is not ascending. Check for descending.
	
ASCEND_UPDATE:
	addi $t0, $t0, 1		# i++.
	j ASCEND_CHECK			# Repeat ascend check loop.
	

	
	# Repeat process to check for descending, but swap the slt.

START_DESCEND:
	addi $t0, $zero, 1		# t0 = (i=1).
	
DESCEND_CHECK:
	slt $t1, $t7, $t0		# t1 = (arrayLen - 1) < i.
	bne $t1, $zero, PRINT_DESCEND	# If this ^ is true, we know list is descending.
	
	addi $t1, $t0, -1		# t1 = i - 1. (previous value).
	sll  $t1, $t1, 2		# t1 = t1 * 4 (index of previous val).
	add  $t1, $t6, $t1		# t1 = pointer to [i-1]
	lw   $t1, 0($t1)		# t1 = intArray[i-1].
	
	add $t2, $zero, $t0		# t2 = i
	sll $t2, $t2, 2			# t2 = i * 4.
	add $t2, $t6, $t2		# Pointer to i idx.
	lw  $t2, 0($t2)			# t4 = intArray[i].
	
	beq $t1, $t2, DESCEND_UPDATE	# If intArray[i-1] = intArray[i], reiterate through loop.
	slt $t3, $t1, $t2		# t3 = intArray[i-1] < intArray[i].
	bne $t3, $zero, NEITHER_CHECK	# If this ^ is true, list is not descending. Check if we did neither.

 DESCEND_UPDATE:
	addi $t0, $t0, 1		# i++.
	j DESCEND_CHECK			# Repeat ascend check loop.
	

PRINT_ASCEND:
	addi $v0, $zero, 4		# Print "Run Check: ASCENDING\n"
	la   $a0, ASCENDING
	syscall
	
	# Update our s5 marker so we know we printed ASCENDING.
	addi $s5, $zero, 1		# s5 = 1 to mark that we have printed ascending.
	
	j DESCEND_CHECK			# Possible it is both, so check descending next.
	
PRINT_DESCEND:
	addi $v0, $zero, 4		# Print "Run Check: DESCENDING\n"
	la   $a0, DESCENDING
	syscall
	
	addi $v0, $zero, 4		# Print "\n".
	la   $a0, NEWLINE
	syscall
	
	j RUN_DONE			# We have now completed runCheck.
	
BOTH:
	addi $v0, $zero, 4		# Print "Run Check: ASCENDING\n"
	la   $a0, ASCENDING
	syscall
	
	addi $v0, $zero, 4		# Print "Run Check: DESCENDING\n"
	la   $a0, DESCENDING
	syscall
	
	addi $v0, $zero, 4		# Print "\n".
	la   $a0, NEWLINE
	syscall
	
	j RUN_DONE			# We have now completed runCheck.
	
NEITHER_CHECK:
	# If s5 = 1, we have already printed ascending and do not need to do anything else.
	# If s5 = 0, we must print we have neither ascending OR descending.
	
	beq $s5, $zero, PRINT_NEITHER	# If s5 = 0, we never printed ascending.
	
	j RUN_DONE			# If it was ascending, we don't print neither and end the function.
	
	
PRINT_NEITHER:
	# If we did not branch, we must print that the array was neither.
	addi $v0, $zero, 4		# Print "Run Check: NEITHER\n"
	la   $a0, NEITHER
	syscall
	
	addi $v0, $zero, 4		# Print "\n".
	la   $a0, NEWLINE
	syscall
	
	j RUN_DONE			# We have now completed runCheck.

# Reached end of runCheck.
RUN_DONE:

### NEXT TASK ###

	# Check if countWords == 1.
	addi $t0, $zero, 1
	bne  $s3, $t0, COUNT_DONE	# If countWords != 1, skip task.
	
	la  $s0, str			# s0 = &str.
	add $t0, $zero, $s0		# t0 = &str
	
	
	add $t1, $zero, $zero	# t1 = (wordCount = 0).
COUNT_WORDS:

	lb  $t2, 0($t0)		# t2 = str[i].
	# Check to see if we have reached the end of the string.
	beq $t2, $zero, FINAL_COUNTPRINT
	
	# Assign our space and newline registers.
	addi $t4, $zero, ' '		# t4 = ' '.
	addi $t5, $zero, '\n'	# t5 = '\n'.
	
	
	# Do not need to check str[i - 1] if we know str[i] is not even in a word.
	beq $t2, $t4, ADD_I		# If str[i] is a space, do not update wordCount.
	beq $t2, $t5, ADD_I		# If str[i] is a newline, do not update wordCount.
	
	lb  $t6, -1($t0)		# t6 = char at the previous index in str.
	
	beq $t6, $zero, ADD_WC	# If previous char is null, it is beginning of str and we should add to WC.
	
	
	# If str[i - 1] is a space or newline, and str[i] is not, we know we have started a new word.
	beq $t6, $t4, ADD_WC		# If str[i - 1] is a space, update wordCount.
	beq $t6, $t5, ADD_WC		# If str[i - 1] is a newline, update wordCount.
	
	j ADD_I			# Make sure to skip over adding to wordCount if prev char is not space/newline.
			
ADD_WC:
	addi $t1, $t1, 1		# wordCount++.
ADD_I:
	addi $t0, $t0, 1		# i++.
	j COUNT_WORDS			# Continue iterating through str.
	
FINAL_COUNTPRINT:
	addi $v0, $zero, 4		# Print "Word Count: ".
	la   $a0, WORDCOUNT
	syscall
	
	addi $v0, $zero, 1		# Print the word count amount.
	add  $a0, $zero, $t1
	syscall
	
	addi $v0, $zero, 4		# Print "\n".
	la   $a0, NEWLINE
	syscall
	
	addi $v0, $zero, 4		# Print "\n".
	la   $a0, NEWLINE
	syscall

COUNT_DONE:


### NEW TASK ###


	beq $s4, $zero, REV_DONE	# If revString == 0, skip task.
	add $t0, $zero, $zero		# t0 = (head = 0).
	add $t1, $zero, $zero		# t1 = (tail = 0).
REV_STRING:
	la $s0, str			# Make sure s0 = &str. (May not have run last task).
	
GET_TAIL:
	add  $t2, $s0, $t1		# t2 = &str[tail].
	lb   $t2, 0($t2)		# t2 = str[tail].
	beq  $t2, $zero, TAIL_FOUND	# If str[tail] == null, we have found our tail.
	addi $t1, $t1, 1		# If not found, tail++.
	j GET_TAIL			# Repeat loop for finding tail.
	
TAIL_FOUND:
	addi $t1, $t1, -1		# tail-- (To make sure we get last non-null char).

SWAP_LOOP:
	slt $t2, $t0, $t1		# t2 = head < tail.
	beq $t2, $zero, SWAP_PRINT	# If this ^ is false, end the loop.
	
	# Get the chars at head and tail idx of str.
	add $t3, $s0, $t0		# t3 = &str[head].
	lb  $t4, 0($t3)		# t4 = str[head].
	add $t5, $s0, $t1		# t5 = &str[tail].
	lb  $t6, 0($t5)		# t6 = str[tail].
	
	# Swap the chars at head and tail idx of str.
	sb $t4, 0($t5)			
	sb $t6, 0($t3)
	
	# Update idx of head and tail.
	addi $t0, $t0, 1		# head++.
	addi $t1, $t1, -1		# tail--.
	
	j SWAP_LOOP			# Repeat the swapping loop.
	

SWAP_PRINT:
	addi $v0, $zero, 4		# Print "String successfully swapped!\n".
	la   $a0, SWAPPED
	syscall
	
	addi $v0, $zero, 4		# Print "\n".
	la   $a0, NEWLINE
	syscall
	
REV_DONE:

	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
EPILOGUE: 	
# Load all original values back to Sx registers.
	lw    $s1, 4($sp)
	lw    $s0, 0($sp)
	addiu $sp, $sp, 8
	
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
