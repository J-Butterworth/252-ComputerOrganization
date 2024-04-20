.data

TURTLE: 	.asciiz "Turtle \""
QUOTATION: 	.asciiz "\"\n"
POS: 		.asciiz "  pos "
DIR: 		.asciiz "  dir "
ODOMETER: 	.asciiz "  odometer "
NORTH:          .asciiz "North"
EAST:          .asciiz "East"
SOUTH:          .asciiz "South"
WEST:          .asciiz "West"
COMMA: 		.asciiz ","
SPACE: 		.asciiz " "
NEWLINE: 	.asciiz "\n"

.text

.globl turtle_init
.globl turtle_debug
.globl turtle_turnLeft
.globl turtle_turnRight
.globl turtle_move
.globl turtle_searchName
.globl turtle_sortByX_indirect


# Constructor for the turtle object. Initializing all fields of the struct.
# Byte diagram has been given in the spec. Get from $a0 register.
turtle_init:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
	sb $zero, 0($a0)		# x = 0.
	sb $zero, 1($a0)		# y = 0.
	sb $zero, 2($a0)		# dir = 0.
	sw $a1,   4($a0)		# Second parameter = name.
	sw $zero, 8($a0)		# Odometer = 0.
	
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code

# Print out all fields of the turtle struct in the correct format.
turtle_debug:

	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
    	addiu $sp, $sp, -8
    	
    	sw $s0, 0($sp)
    	sw $s1, 4($sp)
    	
    	add $s1, $zero, $a0		# Store a0 in s1.

	# Load all bytes and words into temp variables.
	# Need these in order to print out struct.
	
	add  $s0, $zero, $a0		# s0 is our full turtle object.
	
	lb   $t0, 0($s0)		# t0 = x.
	
	#addi $s0, $s0, 1
	lb   $t1, 1($s0)		# t1 = y.
	
	#addi $s0, $s0, 1
	lb   $t2, 2($s0)		# t2 = dir.
	
	# Load word for name and odom, not a single byte anymore.
	# addi $s0, $s0, 2
	lw   $t3, 4($s0)		# t3 = name.
	
	#addi $s0, $s0, 4
	lw   $t4, 8($s0)		# t4 = odometer.
	
	# Begin printing.
	addi $v0, $zero, 4
	la   $a0, TURTLE
	syscall				# Print "Turtle "".
	
	addi $v0, $zero, 4
	add  $a0, $zero, $t3
	syscall				# Print turtle name.
	
	addi $v0, $zero, 4
	la   $a0, QUOTATION
	syscall				# Print "\"\n".
	
	
	addi $v0, $zero, 4
	la   $a0, POS
	syscall				# Print "  pos "
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t0
	syscall				# Print x coordinate.
	
	addi $v0, $zero, 4
	la   $a0, COMMA
	syscall				# Print ","
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t1
	syscall				# Print y coordinate.
	
	addi $v0, $zero, 4
	la   $a0, NEWLINE
	syscall				# Print "\n".
	
	
	addi $v0, $zero, 4
	la   $a0, DIR
	syscall				# Print "  dir ".
	
	# Direction to print varies based on dir number.
	
	addi $t5, $zero, 1		# t5 = 1 (East)
	addi $t6, $zero, 2		# t6 = 2 (South)
	addi $t7, $zero, 3		# t7 = 3 (West)
	beq  $t2, $t5, EAST_PRINT
	beq  $t2, $t6, SOUTH_PRINT
	beq  $t2, $t7, WEST_PRINT
	
	NORTH_PRINT:
	addi $v0, $zero, 4
	la   $a0, NORTH
	syscall				# Print current direction.
	
	j DEBUG_CONTINUE
	
	EAST_PRINT:
	addi $v0, $zero, 4
	la   $a0, EAST
	syscall				# Print current direction.
	
	j DEBUG_CONTINUE
	
	SOUTH_PRINT:
	addi $v0, $zero, 4
	la   $a0, SOUTH
	syscall				# Print current direction.
	
	j DEBUG_CONTINUE
	
	WEST_PRINT:
	addi $v0, $zero, 4
	la   $a0, WEST
	syscall				# Print current direction.
	
	DEBUG_CONTINUE:
	
	addi $v0, $zero, 4
	la   $a0, NEWLINE
	syscall				# Print "\n".
	
	addi $v0, $zero, 4
	la   $a0, ODOMETER
	syscall				# Print "  odometer ".
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t4
	syscall				# Print odometer count.
	
	addi $v0, $zero, 4
	la   $a0, NEWLINE
	syscall				# Print "\n".
	
	addi $v0, $zero, 4
	la   $a0, NEWLINE
	syscall				# Print "\n".
	
	
	add $a0, $zero, $s1		# Reinstate original a0 from s1.
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	
	addiu $sp, $sp, 8
	
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	
	

# Next two functions must rotate the turtle's direction 90 degrees.
# Keep direction format from [0,3] inclusive.

turtle_turnLeft:
	
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
	
	# Get current direction.
	lb   $t0, 2($a0)		# t0 = current turtle direction.
	
	add  $t1, $zero, $zero		# t1 = 0 (North)
	
NORTH_CHECK:
	bne  $t0, $t1, EAST_CHECK	# If curr dir is not North, check for East.
	addi $t0, $zero, 3		# If t0 = 0 (North), new dir = 3 (West).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_LEFT_DONE

EAST_CHECK:
	addi $t1, $t1, 1		# t1 = 1. (East)
	bne  $t0, $t1, SOUTH_CHECK	# If curr dir is not East, check for South.
	addi $t0, $t0, -1		# Update new dir from 1 (East) to 0 (North).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_LEFT_DONE
	
SOUTH_CHECK:
	addi $t1, $t1, 1		# t1 = 2. (South)
	bne  $t0, $t1, WEST_CHECK	# If curr dir is not South, we know it is West.
	addi $t0, $t0, -1		# Update new dir from 2 (South) to 1 (East).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_LEFT_DONE

WEST_CHECK:	
	addi $t1, $t1, 1		# t1 = 3. (West)
	addi $t0, $t0, -1		# Update new dir from 3 (West) to 2 (South).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_LEFT_DONE
	
TURN_LEFT_DONE:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	

# Repeat same process as turnLeft, but add to direction instead.
turtle_turnRight:

	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
	# Get current direction.
	lb   $t0, 2($a0)		# t0 = current turtle direction.
	
	add  $t1, $zero, $zero		# t1 = 0 (North)
	
NORTH_CHECK2:
	bne  $t0, $t1, EAST_CHECK2	# If curr dir is not North, check for East.
	addi $t0, $t0, 1		# If t0 = 0 (North), new dir = 1 (East).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_RIGHT_DONE	

EAST_CHECK2:
	addi $t1, $t1, 1		# t1 = 1. (East)
	bne  $t0, $t1, SOUTH_CHECK2	# If curr dir is not East, check for South.
	addi $t0, $t0, 1		# Update new dir from 1 (East) to 2 (South).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_RIGHT_DONE
	
SOUTH_CHECK2:
	addi $t1, $t1, 1		# t1 = 2. (South)
	bne  $t0, $t1, WEST_CHECK2	# If curr dir is not South, we know it is West.
	addi $t0, $t0, 1		# Update new dir from 2 (South) to 3 (West).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_RIGHT_DONE
	
WEST_CHECK2:	
	addi $t1, $t1, 1		# t1 = 3. (West)
	add  $t0, $zero, $zero		# Update new dir from 3 (West) to 0 (North).
	sb   $t0, 2($a0)		# Store new dir back into turtle object.
	j TURN_RIGHT_DONE
	
TURN_RIGHT_DONE:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	

# Move turtle in its current direction based on the distance indicated.
turtle_move:

MOVE_PRO:

	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer


	# Get current direction.
	lb  $t0, 2($a0)			# t0 = current turtle direction.

	addi $t1, $zero, 1		# t1 = 1 (East).
	addi $t2, $zero, 2		# t2 = 2 (South).
	addi $t3, $zero, 3		# t3 = 3 (West).

	beq $t0, $t1, MOVE_EAST		# If t0 = 1, moving East.
	beq $t0, $t2, MOVE_SOUTH	# If t0 = 2, moving South.
	beq $t0, $t3, MOVE_WEST		# If t0 = 3, moving West.
	

MOVE_NORTH:
	lb   $t1, 1($a0)		# t1 = y coordinate.
	add  $t2, $t1, $a1		# t2 = y coordinate + distance to travel.
	
	slti $t3, $t2, 10		# t3 = ((y coord + dist) < 10)
	beq  $t3, $zero, NORTH_TEN	# If this ^ is false (so it is greater than 10), we know y coord will be raised to 10.
	
	slti $t3, $t2, -10		# t3 = ((y coordinate+dist) < 0)
	bne  $t3, $zero, NORTH_NEGTEN	# If this ^ is true, we know y coord will be dropped to 0.
	
NORTH_SHIFT:
	add $t1, $t1, $a1		# Shift the y coordinate.
	
NORTH_END:
	sb $t1, 1($a0)			# Store updated y coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update odometer.
	
NORTH_TEN:
	addi $t1, $zero, 10		# Update y coordinate to equal 10.
	sb   $t1, 1($a0)		# Store updated y coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.

NORTH_NEGTEN:
	addi   $t1, $zero, -10		# Update y coordinate to equal 0.
	sb     $t1, 1($a0)		# Store updated y coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.
	
MOVE_EAST:
	lb   $t1, 0($a0)		# t1 = x coordinate.
	add  $t2, $t1, $a1		# t2 = x coordinate + distance to travel.
	
	slti $t3, $t2, 10		# t3 = ((x coord + dist)<10)
	beq  $t3, $zero, EAST_TEN	# If this ^ is false (so it is greater than 10), we know x coord will be raised to 10.
	
	slti $t3, $t2, -10		# t3 = ((x coordinate+dist) < 0)
	bne  $t3, $zero, EAST_NEGTEN	# If this ^ is true, we know x coord will be dropped to 0.
	
	
EAST_SHIFT:
	add $t1, $t1, $a1		# Shift x coordinate.
	
EAST_END:
	sb $t1, 0($a0)			# Store updated x coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update odometer.
	
EAST_TEN:
	addi $t1, $zero, 10		# Update x coordinate to equal 10.
	sb   $t1, 0($a0)		# Store updated x coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.

EAST_NEGTEN:
	addi  $t1, $zero, -10		# Update x coordinate to equal 0.
	sb    $t1, 1($a0)		# Store updated x coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.
	

MOVE_SOUTH:
	lb   $t1, 1($a0)		# t1 = y coordinate.
	sub  $t2, $t1, $a1		# t2 = y coordinate - distance to travel.
	
	slti $t3, $t2, 10		# t3 = ((y coord - dist)<10)
	beq  $t3, $zero, SOUTH_TEN	# If this ^ is false (so it is greater than 10), we know y coord will be raised to 10.
	
	slti $t3, $t2, -10		# t3 = ((y coordinate-dist) < 0)
	bne  $t3, $zero, SOUTH_NEGTEN	# If this ^ is true, we know y coord will be dropped to 0.
	
SOUTH_SHIFT:
	sub $t1, $t1, $a1		# Shift y coordinate.
	
SOUTH_END:
	sb $t1, 1($a0)			# Store updated y coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update odometer.
	
SOUTH_TEN:
	addi $t1, $zero, 10		# Update y coordinate to equal 10.
	sb   $t1, 1($a0)		# Store updated y coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.

SOUTH_NEGTEN:
	addi   $t1, $zero, -10		# Update y coordinate to equal 0.
	sb     $t1, 1($a0)		# Store updated y coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.
	
MOVE_WEST:
	lb   $t1, 0($a0)		# t1 = x coordinate.
	sub  $t2, $t1, $a1		# t2 = x coordinate - distance to travel.
	
	slti $t3, $t2, 10		# t3 = ((x coord - dist)<10)
	beq  $t3, $zero, WEST_TEN	# If this ^ is false (so it is greater than 10), we know x coord will be raised to 10.
	
	slti $t3, $t2, -10		# t3 = ((x coordinate-dist) < 0)
	bne  $t3, $zero, WEST_NEGTEN	# If this ^ is true, we know x coord will be dropped to 0.
	
WEST_SHIFT:
	sub $t1, $t1, $a1		# Assign new x coordinate.
	
WEST_END:
	sb $t1, 0($a0)			# Store updated x coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update odometer.
	
WEST_TEN:
	addi $t1, $zero, 10		# Update x coordinate to equal 10.
	sb   $t1, 0($a0)		# Store updated x coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.

WEST_NEGTEN:
	addi  $t1, $zero, -10		# Update x coordinate to equal 0.
	sb    $t1, 0($a0)		# Store updated x coordinate back to object.
	j UPDATE_ODOMETER		# Jump to update the odometer.
	

# Update the odometer by whatever amount the distance is, not clamped.
UPDATE_ODOMETER:
	# la   $t0, 0($a0)
	lw   $t0, 8($a0)		# t0 = odometer.
	slti $t2, $a1, 0		# t2 = distance < 0.
	beq  $t2, $zero, POSITIVE	# If this ^ is false, distance is positive.
	
	NEGATIVE:
	sub $a1, $zero, $a1		# Get absolute value of distance.
	add $t0, $t0, $a1		# Add absolute distance to odometer.
	sw  $t0, 8($a0)			# Store the updated odometer count back into object.
	j MOVE_END 
	
	POSITIVE:
	add $t0, $t0, $a1		# t0 = odometer+=distance traveled.
	sw  $t0, 8($a0)			# Store the updated odometer count back into object.
	
MOVE_END:
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code

# Search array of turtle structs, locating a specific name.
turtle_searchName:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
	# Save sX registers so we can use aX for strcmp() later.
	addiu $sp, $sp, -24
	sw    $s0, 0($sp)
	sw    $s1, 4($sp)
	sw    $s2, 8($sp)
	sw    $s3, 12($sp)
	sw    $s4, 16($sp)
	sw    $s5, 20($sp)
	
	add $s0, $zero, $a0		# s0 = Array
	add $s1, $zero, $a1		# s1 = Array.length
	add $s2, $zero, $zero		# s2 = (i = 0)
	
	add $s3, $zero, $a0		# s3 will hold meta struct.
	add $s4, $zero, $a1		# s4 will hold array length.
	add $s5, $zero, $a2

	
NAME_LOOP:
	slt $t3, $s2, $s1		# t3 = (i < Array.length)
	beq $t3, $zero, NO_MATCH	# If this ^ is no longer true, we know name is not in the array.
	
	lw  $t1, 4($s0)			# t1 is looking at first turtle name.
	
	add $a0, $zero, $t1		# a0 = current name.
	add $a1, $zero, $s5		# a1 = Needle name to look for.
	jal strcmp			# Pass a0 and a1 into strcmp function.
	
	# In C, strcmp returns 0 if strings are equal.
	beq  $v0, $zero, MATCH		# If v0 == 0, we have found a match.
	
	addi $s0, $s0, 12		# If no match yet, update to next turtle object.
	addi $s2, $s2, 1		# i++
	j NAME_LOOP			# Repeat loop.
		
MATCH:
	add $v0, $zero, $s2		# Return value = i (Array Index)
	j NAME_FINISH			# Jump to finish the function.
	

NO_MATCH:		
	addi $v0, $zero, -1		# Return value = -1 (Index saying name was not found.)
	j NAME_FINISH			# Jump to finish the function.
	
NAME_FINISH:
	# Tie off all loose ends with stack.
	
	add $a0, $zero, $s3		# Restore original a0.
	add $a1, $zero, $s4		# Restore original a1.
	
	# Load all original values back to Sx registers.
	lw    $s5, 20($sp)
	lw    $s4, 16($sp)
	lw    $s3, 12($sp)
	lw    $s2, 8($sp)
	lw    $s1, 4($sp)
	lw    $s0, 0($sp)
	addiu $sp, $sp, 24
	
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code
	
turtle_sortByX_indirect:
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
   	sw    $fp, 0($sp) 		# save caller’s frame pointer
    	sw    $ra, 4($sp) 		# save return address
    	addiu $fp, $sp, 20 		# setup main’s frame pointer
    	
    	# Save sX registers in memory.
    	addiu $sp, $sp, -20
	sw    $s0, 0($sp)
	sw    $s1, 4($sp)
	sw    $s2, 8($sp)
	sw    $s3, 12($sp)
	sw    $s4, 16($sp)
	
	# Get boundary for outer loop.
	add  $s0, $zero, $zero		# s0 = (i=0)
	addi $s1, $a1, -1		# s1 = Array.length-1.
	
# Loop to sort Turtles by x values using Bubble Sort
SORTX_LOOP:
        slt $t0, $s0, $s1            	# t0 = (i < Array.length - 1)
    	beq $t0, $zero, SORTX_DONE   	# If this ^ is false, we know we have finsihed our outer loop.
    
    	add $s2, $zero, $zero		# s2 = (j=0)
	
    	# Get boundary for inner loop.
    	sub $t1, $s1, $s0		# t1 = Array.length-1-i.	

INNER_LOOP:
    	slt $t0, $s2, $t1		# Reset t0 = (j < Array.length - 1 - i.)
    	
    	beq $t0, $zero, ADD_I		# If this ^ is false, we need to do i++.
    	
    	sll $t2, $s2, 2			# t2 = j*4
    	
    	# Grab addresses from marker at i+j.
    	# This makes sure we go from i instead of 0 in inner loop.
    	add  $t2, $t2, $a0		# t2 = Address at i + our j marker.
    	
    	# Diagram shows that next pointer will be 4 bytes ahead.
    	addi $t3, $t2, 4		# t3 = Address at i + our j marker + 4. 
    	
    	lw $s3, 0($t2)			# s3 = The POINTER to turtle[j], not the actual object yet.
    	lw $s4, 0($t3)			# s4 = The POINTER to turtle[j+1], not the actual object yet.
    	
    	# X coordinate requires lb, diagram shows coordinate takes up one byte from turtle object.
    	lb $s5, 0($s3)			# s5 = x coordinate at turtle[j]
    	lb $s6, 0($s4)			# s6 = x coordinate at turtle[j+1]
    	
    	# Do slt in a way that includes no switching for j<=j+1, not just j<j+1.
    	slt $t5, $s6, $s5		# t5 = (x coordinate at turtle[j+1] < x coordinate at turtle[j]).
    	beq $t5, $zero, ADD_J		# If this ^ is false, we do not need to switch them, just j++.
    	
    	# Otherwise, swap the POINTERS, NOT actual turtle objects!
    	sw $s3, 0($t3)
    	sw $s4, 0($t2)
    	
ADD_J:
    	addi $s2, $s2, 1		# j++.
    	j INNER_LOOP
    	
ADD_I:
    	addi $s0, $s0, 1          	# i++.
    	j SORTX_LOOP             	# Continue with next iteration of the loop


SORTX_DONE:
	# Once we have iterated through outer loop fully, restore stack.
	
	# Load all original values back to Sx registers.
	lw    $s4, 16($sp)
	lw    $s3, 12($sp)
	lw    $s2, 8($sp)
	lw    $s1, 4($sp)
	lw    $s0, 0($sp)
	addiu $sp, $sp, 20
	
	lw    $ra, 4($sp) 		# get return address from stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra 			# return to caller’s code