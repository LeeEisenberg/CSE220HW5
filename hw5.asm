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
	lw $t1 0($t0) #load credits
	li $t2 0x000003FF #make mask
	and $t1 $t1 $t2 #use it
	li $v0 36 #unsigned int
	move $a0 $t1
	syscall
	li $v0 11 #char
	li $a0 32 #space
	syscall
	lw $t1 0($t0) #load ID
	srl $t1 $t1 10
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
	
init_student_array:
	jr $ra
	
insert:
	jr $ra
	
search:
	jr $ra

delete:
	jr $ra
