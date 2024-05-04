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
	sw $t2 -28($sp)
	addi $sp $sp -32
	lw $a0 0($a1)
	lw $a1 0($a2)
	move $a2 $a3
	move $a3 $t0
	jal init_student
	#restore a and s
	addi $sp $sp 32
	lw $a0 -4($sp)
	lw $a1 -8($sp)
	lw $a2 -12($sp)
	lw $a3 -16($sp)
	lw $t0 -20($sp)
	lw $t1 -24($sp)
	lw $t2 -28($sp)
	addiu $a0 $a0 -1 #subtract 1 from things left
	beq $a0 $zero init_student_array_end #if its 0 die
	addiu $a1 $a1 4 #next ID
	addiu $a2 $a2 4 #next credit
	addiu $t0 $t0 8 #next record
	init_student_array_loop:
		lb $t1 0($a3) #load char
		and $t1 $t1 $t2 #mask char
		addiu $a3 $a3 1 #next char
		bne $t1 $zero init_student_array_loop #if its null break
	j init_student_array_start #loop
init_student_array:
	lw $t0 0($sp) #store dest array $t0
	sw $ra 0($sp) #store $ra in $sp
	li $t2 0x000000FF #char mask
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
	beqz $a2 search_fail #if table size 0 die
	div $a0 $a2 #calc array index
	mfhi $t0 #initial index
	move $t1 $t0 #current index
	li $t2 4
	li $t4 -1
search_index:
	mul $t3 $t1 $t2 
	add $t3 $t3 $a1 #current address
	lw $t3 0($t3) #grab pointer
	beqz $t3 next_index #if null skip
	beq $t3 $t4 next_index #if tomb skip
	lw $t5 0($t3)
	srl $t5 $t5 10 #get ID
	beq $t5 $a0 search_found #check if its the right ID
next_index:
	addi $t1 $t1 1
	beq $t1 $t0 search_fail #couldnt find
	blt $t1 $a2 search_index #loop if not oob
	li $t1 0
	j search_index
search_found:
	move $v0 $t3
	move $v1 $t1
	jr $ra
search_fail:
	li $v0 0
	li $v1 -1
	jr $ra

delete:
	sw $ra -4($sp)
	sw $a0 -8($sp)
	sw $a1 -12($sp)
	sw $a2 -16($sp)
	addi $sp $sp -20
	jal search
	addi $sp $sp 20
	lw $ra -4($sp)
	sw $a0 -8($sp)
	sw $a1 -12($sp)
	sw $a2 -16($sp)
	beqz $v0 delete_fail
	li $t0 4
	mul $t0 $t0 $v1
	add $t0 $t0 $a1 #index of pointer
	li $t1 -1
	sw $t1 0($t0) #tombstone the pointer
	move $v0 $v1
	jr $ra
delate_fail:
	li $v0 -1
	jr $ra
