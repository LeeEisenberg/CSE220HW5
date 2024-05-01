.text

init_student:
	move $t0 $a1 #grab credits
	move $t1 $a0 #grab ID
	sll $t1 $t1 10 #align ID
	or $t0 $t0 $t1 #combine them
	sw $t0 0($a3)
	move $t0 $a2 #grab name ptr
	sw $t0 32($a3)
	jr $ra
	
print_student:
	move $t0 $a0 #store address
	lw $t1 0($t0) #load ID
	srl $t1 $t1 10
	li $v0 36 #unsigned int
	move $a0 $t1
	syscall
	li $v0 11 #char
	li $a0 32 #space
	syscall
	lw $t1 0($t0) #load credits
	li $t2 0x000003FF #make mask
	and $t1 $t1 $t2 #use it
	li $v0 36 #unsigned int
	move $a0 $t1
	syscall
	li $v0 11 #char
	li $a0 32 #space
	syscall
	lw $t1 32($t0) #load name ptr
	li $v0 4 #str
	move $a0 $t1
	syscall
	jr $ra
	
init_student_array_start:
	#store a and s
	sw $a0 -4($sp)
	sw $a1 -8($sp)
	sw $a2 -12($sp)
	sw $a3 -16($sp)
	sw $t0 -20($sp)
	sw $t5 -24($sp)
	sw $t6 -28($sp)
	sw $t7 -32($sp)
	sw $t4 -36($sp)
	addi $sp $sp -36
	lw $a0 0($a1)
	lw $a1 0($a2)
	move $a2 $a3
	sub $a2 $a2 $t4
	move $a3 $t0
	jal init_student
	#restore a and s
	addi $sp $sp 36
	lw $a0 -4($sp)
	lw $a1 -8($sp)
	lw $a2 -12($sp)
	lw $a3 -16($sp)
	lw $t0 -20($sp)
	lw $t5 -24($sp)
	lw $t6 -28($sp)
	lw $t7 -32($sp)
	sw $t4 -36($sp)
	addiu $a0 $a0 -1 #subtract 1 from things left
	addiu $a1 $a1 4 #next ID
	addiu $a2 $a2 4 #next credit
	addiu $t0 $t0 8 #next record
	init_student_array_loop:
		lw $t7 0($a3) #load char
		and $t6 $t7 $t5 #use mask to isolate char
		addiu $a3 $a3 4 #next 4 chars
		li $t4 3 #offset
		beq $t6 $zero init_student_array_loop_end
		srl $t7 $t7 8
		and $t6 $t7 $t5 #use mask to isolate char
		li $t4 2 #offset
		beq $t6 $zero init_student_array_loop_end
		srl $t7 $t7 8
		and $t6 $t7 $t5 #use mask to isolate char
		li $t4 1 #offset
		beq $t6 $zero init_student_array_loop_end
		srl $t7 $t7 8
		and $t6 $t7 $t5 #use mask to isolate char
		li $t4 0 #offset
		bne $t6 $zero init_student_array_loop #if its null break
init_student_array_loop_end:
	beq $a0 $zero init_student_array_end #if its 0 die
	bne $a0 $zero init_student_array_start #if not loop
init_student_array:
	li $t5 0x000000FF #make mask
	lw $t0 0($sp) #store dest array $t0
	sw $ra 0($sp) #store $ra in $sp
	beq $a0 $zero init_student_array_end #if its 0 die
	bne $a0 $zero init_student_array_start #if not loop
init_student_array_end:
	lw $ra 0($sp) #reload $ra
	addi $sp $sp 4
	jr $ra
	
insert:
	jr $ra
	
search:
	jr $ra

delete:
	jr $ra
