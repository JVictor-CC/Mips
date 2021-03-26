.data
vetor:  .word 3, 7, 5, 8, 7, 8, 2, 7, 5, 4
msgmedia:    .asciiz "Calculo da Media: "

msgvariancia:   .asciiz "Calculo da Variancia: "  
            
        .text
        la $a0, vetor
        li $a1, 10	#Numero de componentes do mvetor
        jal media
        move $s3, $v0
        li $v0,4     #Printa a string msg
        la $a0,msgmedia
        syscall
        li $v0,1     #Printa a media
        move $a0,$s3
        syscall
        li $v0,11     #Printa '\n'
        li $a0,'\n'
        syscall 
        syscall   
        la $a0, vetor	#começo da Variancia
        li $a1, 10
        jal variancia
        move $s4, $v0
        li $v0,4     #Printa a string msg2
        la $a0,msgvariancia
        syscall
        li $v0,1     #Printa a variancia
        move $a0,$s4
        syscall
        li $v0,11     #Printa '\n'
        li $a0,'\n'
        syscall
        li $v0,10     #Fim dp programa
        syscall
        
        
media:	addi $sp,$sp,-12  #$s0 <- vetor  $s1 <- tamanho do vetor (N) $s2 <- indice do for
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	move $s0,$a0
	move $s1,$a1
	li $t0,0        # $t0 será a media
	li $s2,0        #inicializa i = 0 fora do loop
loop:	beq $s2,$s1,saida   #for
	add $t1,$s2,$s2
	add $t1,$t1,$t1  # calcula i * 4
	add $t1,$t1,$s0  # soma o endereço base do vetor
	lw $t2,0($t1)    # le o dado do vetor em vetor[i]
	add $t0,$t0,$t2  # faz o calculo cumulativo da media
	addi $s2,$s2,1   # i = i + 1
	j loop
saida:	div $t0,$s1      # divide o somatorio por N
	mflo $v0         # pega o resultado da divisão e coloca no $v0
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        addi $sp,$sp,12
	jr $ra
        
variancia: addi $sp,$sp,-12  #$s0 <- vetor  $s1 <- tamanho do vetor (N) $s2 <- indice do for
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	move $s0,$a0
	move $s1,$a1
	li $t0,0        # $t0 será a variancia
	li $s2,0        #inicializa i = 0 fora do loop
loop2:	beq $s2,$s1,exit   #for
	add $t1,$s2,$s2
	add $t1,$t1,$t1  # calcula i * 4
	add $t1,$t1,$s0  # soma o endereço base do vetor
	lw $t2,0($t1)    # le o dado do vetor em vetor[i]
	sub $t3,$t2,$s3  # subtrai do dado do vetor o valor da media (vetor[i]-media)
	mul $t3,$t3,$t3  # tira o quadrado do resultado da operação acima
	add $t0,$t0,$t3  # faz o calculo cumulativo da variância
	addi $s2,$s2,1   # incremento do for (i = i + 1) 
	j loop2
exit:	div $t0,$s1      # divide o somatorio por N
	mflo $v0         # pega o resultado da divisão e coloca no $v0
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        addi $sp,$sp,12
	jr $ra
