#p3210265 Giorgos Athanasopoulos
	.text
	.globl main
main:
# do {
firstdo:
	# print "Number: "
	la $a0,numbertext
	li $v0,4
	syscall

	# read number1
	li $v0,5
	syscall
	sw $v0,number1

	# result = number1
	lw $t0,number1
	sw $t0,result

#	do {
seconddo:
	# print "Operator: "
	la $a0,operatortext
	li $v0,4
	syscall

	# read operator
	li $v0,12
	syscall
	sh $v0,operator

	la $a0,crlf
	li $v0,4
	syscall

	# if operator not in ['+', '-', '*', '/', '%', '=']
	lb $t1,plus
	lb $t2,operator
	beq $t1,$t2,validoperator

	lb $t1,minus
	lb $t2,operator
	beq $t1,$t2,validoperator

	lb $t1,multiplicationsign
	lb $t2,operator
	beq $t1,$t2,validoperator

	lb $t1,forwardslash
	lb $t2,operator
	beq $t1,$t2,validoperator

	lb $t1,remainder
	lb $t2,operator
	beq $t1,$t2,validoperator

	lb $t1,equals
	lb $t2,operator
	beq $t1,$t2,validoperator

	# print error
	la $a0,operatorerrortext
	li $v0,4
	syscall

	# exit
	j exit
validoperator:
	# if operator not '='
	lb $t1,operator
	lb $t2,equals
	beq $t1,$t2,endassignment

	# print "Number: "
	la $a0,numbertext
	li $v0,4
	syscall

	# read number2
	li $v0,5
	syscall
	sw $v0,number2

	# if number2 is zero and operator in ['/', '%']
	lw $t1,number2
	bne $t1,$zero,resultassignment

	lb $t1,operator
	lb $t2,forwardslash
	beq $t1,$t2,dividebyzeroerror

	lb $t1,operator
	lb $t2,remainder
	beq $t1,$t2,dividebyzeroerror

	j resultassignment

dividebyzeroerror:
	# print error
	la $a0,dividebyzerotext
	li $v0,4
	syscall

	# exit
	j exit
resultassignment:
	# result = result operator number2
	lb $t1,operator
	lb $t2,plus
	beq $t1,$t2,plusop
	lb $t1,operator
	lb $t2,minus
	beq $t1,$t2,minusop
	lb $t1,operator
	lb $t2,multiplicationsign
	beq $t1,$t2,multiplicationsignop
	lb $t1,operator
	lb $t2,forwardslash
	beq	$t1,$t2,forwardslashop
	lb $t1,operator
	lb $t2,remainder
	beq	$t1,$t2,remainderop
plusop:
	lw $t1,result
	lw $t2,number2
	add $s1,$t1,$t2
	sw $s1,result
	j endassignment
minusop:
	lw $t1,result
	lw $t2,number2
	sub $s1,$t1,$t2
	sw $s1,result
	j endassignment
multiplicationsignop:
	lw $t1,result
	lw $t2,number2
	mul $s1,$t1,$t2
	sw $s1,result
	j endassignment
forwardslashop:
	lw $t1,result
	lw $t2,number2
	div $s1,$t1,$t2
	sw $s1,result
	j endassignment
remainderop:
	lw $t1,result
	lw $t2,number2
	rem $s1,$t1,$t2
	sw $s1,result
	j endassignment

endassignment:
	# while operator not '='
	lb $t1,operator
	lb $t2,equals
	bne $t1,$t2,seconddo

	# print result
	la $a0,resulttext
	li $v0,4
	syscall

	lw $a0,result
	li $v0,1
	syscall

	la $a0,crlf
	li $v0,4
	syscall

	# ask user if he wants to continue with a new expression
	la $a0, newexpressiontext
	li $v0,4
	syscall

	# read answser
	li $v0,12
	syscall
	sb $v0,answer

	la $a0,crlf
	li $v0,4
	syscall

	# while answer is not 'n'
	lb $t1,answer
	lb $t2,yes
	beq $t1,$t2,firstdo

exit:
	li $v0,10
	syscall

	.data
numbertext: .asciiz "Number: "
operatortext: .asciiz "Operator: "
operatorerrortext:.asciiz "Error: Invalid operator.\n"
dividebyzerotext: .asciiz "Error: Divide by zero.\n"
newexpressiontext: .asciiz "Do you want to continue with a new expression? (y/n) "
resulttext: .asciiz "The result is: "
crlf: .asciiz "\n"

operator: .space 1
answer: .space 1

number1: .space 4
number2: .space 4
result: .space 4

yes: .byte 'y'
equals: .byte '='
plus: .byte '+'
minus: .byte '-'
multiplicationsign: .byte '*'
forwardslash: .byte '/'
remainder: .byte '%'
