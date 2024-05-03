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
	sw $t1 -24($sp)
	addi $sp $sp -24
	lw $a0 0($a1)
	lw $a1 0($a2)
	move $a2 $a3
	move $a3 $t0
	jal init_student
	#restore a and s
	addi $sp $sp 24
	lw $a0 -4($sp)
	lw $a1 -8($sp)
	lw $a2 -12($sp)
	lw $a3 -16($sp)
	lw $t0 -20($sp)
	lw $t1 -24($sp)
	addiu $a0 $a0 -1 #subtract 1 from things left
	addiu $a1 $a1 4 #next ID
	addiu $a2 $a2 4 #next credit
	addiu $t0 $t0 8 #next record
	init_student_array_loop:
		lb $t1 0($a3) #load char
		addiu $a3 $a3 1 #next char
		bne $t1 $zero init_student_array_loop #if its null break
init_student_array_loop_end:
	beq $a0 $zero init_student_array_end #if its 0 die
	bne $a0 $zero init_student_array_start #if not loop
init_student_array:
	lw $t0 0($sp) #store dest array $t0
	sw $ra 0($sp) #store $ra in $sp
	beq $a0 $zero init_student_array_end #if its 0 die
	bne $a0 $zero init_student_array_start #if not loop
init_student_array_end:
	lw $ra 0($sp) #reload $ra
	addi $sp $sp 4
	jr $ra
	
insert:
	lw $t0 0($a0) #load ID
	srl $t0 $t0 10
	div $t0 $a2 #calcuilate array index
	mfhi $t1 #t1 holds initial array index
	move $t2 $t1 #t2 is current array index
	li $t3 4
	li $t6 -1
insert_loop_start:
	mul $t5 $t2 $t3
	add $t5 $t5 $a1 #address of current index
	lw $t4 0($t5)
	beq $t4 $zero insert_loop_end #if spot is empty leave loop
	beq $t4 $t6 insert_loop_end #if tombstone leave loop
	addi $t2 $t2 1 #increment
	beq $t2 $t1 insert_full #checked all spots
	blt $t2 $a2 insert_loop_start #back to start if not out of bounds
	li $t2 0 #set $t2 to beginning if oob
	beq $t2 $t1 insert_full #checked all spots
	j insert_loop_start #loop
insert_loop_end:
	sw $a0 0($t5)
	move $v0 $t2
	jr $ra
insert_full:
	li $v0 -1
	jr $ra
	
search:
	jr $ra

delete:
	jr $ra
