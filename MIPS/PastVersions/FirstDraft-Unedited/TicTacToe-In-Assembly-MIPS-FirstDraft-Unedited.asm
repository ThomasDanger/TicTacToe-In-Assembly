.data
table: .word 0,0,0,0,0,0,0,0,0
X: .asciiz " [ X ]"
O: .asciiz " [ O ]"
Empty: .asciiz " [   ]"
endl: .asciiz "\n"
XWins: .asciiz "X WINS"
OWins: .asciiz "O WINS"
Tie: .asciiz "TIE"
SpaceOccuppied: .asciiz "SPACE OCCUPIED | ENTER SELECTION AGAIN \n"
InvalidChar: .asciiz "INVALID CHARACTER | ENTER X OR O \n"
InvalidPosition: .asciiz "PLEASE SELECT A POSITION 0-8\n"
ChooseChar: .asciiz "TYPE X OR O TO CHOOSE GAME PIECE: "
PlayerChar: .space 3
Instruction: .asciiz "Welcome to Tic-Tac-Toe \n - Start by entering X or O to choose your gamepiece \n - then, enter the position you would like to play for that turn \n - The positions are shown below \n - Good Luck! (You probably won't need it this AI is not very bright)\n\n [ 0 ] [ 1 ] [ 2 ]\n [ 3 ] [ 4 ] [ 5 ]\n [ 6 ] [ 7 ] [ 8 ] \n"
EnterPosition: .asciiz "ENTER DESIRED POSITION: "

.text
la $s0, table #s0 holds array adress
li $s4, 0

la $a0, Instruction
li $v0, 4
syscall

PromptForChar: #Ask user to enter 1 or 0 for X or O respectively
la $a0, ChooseChar
li $v0, 4
syscall

ReadChar:
la $a0, PlayerChar
li $a1, 3
li $v0, 8
syscall

la $t0, PlayerChar
lbu $t0, 0($t0)

li $t1,79
beq $t0, $t1, ChoseO
li $t1, 88
beq $t0, $t1, ChoseX


la $a0, InvalidChar
li $v0, 4
syscall
j ReadChar

ChoseX:
li $s1, 1
li $s2, -1
j PlayerTurn
ChoseO:
li $s1, -1
li $s2, 1
j CPUTurn

PlayerTurn:
la $a0, EnterPosition
li $v0, 4
syscall
li $v0, 5
syscall
move $t0, $v0
blt $t0, 0, UserPositionInvalid
bgt $t0, 8, UserPositionInvalid
j UserPositionValid
UserPositionInvalid:
la $a0, InvalidPosition
li $v0, 4
syscall
j PlayerTurn
UserPositionValid:
sll $t0, $t0, 2
add $s0, $s0, $t0
add $s4, $s4, $t0
lw $t2, 0($s0)
beq $t2, 0, UserInputValid
sub $s0, $s0, $t0
la $a0, SpaceOccuppied
li $v0, 4
syscall
j PlayerTurn
UserInputValid:
sw $s1, 0($s0)
sub $s0, $s0, $t0
sub $s4, $s4, $t0
li $t0, 0
jal PrintTable
jal CheckWinner
jal CheckTie

CPUTurn:

li $t1, 0
whileNot0:
add $s0, $s0, $t1
add $s4, $s4, $t1
lw $t2, 0($s0)

beq  $t2, $0, EndWhileNot0
sub $s0, $s0, $t1
sub $s4, $s4, $t1
addi $t1, $t1, 4
j whileNot0
EndWhileNot0:
sw $s2, 0($s0)
sub $s0, $s0, $t1
sub $s4, $s4, $t1
jal PrintTable
jal CheckWinner
jal CheckTie
j PlayerTurn

CheckWinner:
CheckHorizontals:
li $t0, 0
lw $t1, 0($s0)
add $t0, $t0, $t1
lw $t1, 4($s0)
add $t0, $t0, $t1
lw $t1, 8($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

li $t0, 0
lw $t1, 12($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 20($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

li $t0, 0
lw $t1,24($s0)
add $t0, $t0, $t1
lw $t1, 28($s0)
add $t0, $t0, $t1
lw $t1, 32($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

CheckVerticals:
li $t0, 0
lw $t1, 0($s0)
add $t0, $t0, $t1
lw $t1, 12($s0)
add $t0, $t0, $t1
lw $t1, 24($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

li $t0, 0
lw $t1, 4($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 28($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

li $t0, 0
lw $t1,8($s0)
add $t0, $t0, $t1
lw $t1, 20($s0)
add $t0, $t0, $t1
lw $t1, 32($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

CheckDiagonals:
li $t0, 0
lw $t1, 0($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 32($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

li $t0, 0
lw $t1, 8($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 24($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

jr $ra

CheckTie:
li $t0, 0
ForEveryElement:
beq $t0, 9, TieProcedure
sll $t1, $t0, 2
add $s0, $s0, $t1
lw $t2, 0($s0)
sub $s0, $s0, $t1
addi $t0, $t0, 1
beq $t2, $0, endForEveryElement
j ForEveryElement
endForEveryElement:
jr $ra




PrintTable:
move $s3, $ra
li $t0, 0
li $t4, 36
WhileLessThan9:
bge $t0, $t4, EndWhileLessThan9
li $t5, 3
div $t0, $t5
mfhi $t5
bne $t5, $0, NoEndl
la $a0, endl
li $v0, 4
syscall
NoEndl:
add $s0, $s0, $t0
add $s4, $s4, $t0
lw $t1, 0($s0)
sub $s0, $s0, $t0
sub $s4, $s4, $t0
li $t2, 1
li $t3, -1
CheckX:
bne $t1, $t2, CheckO
jal PrintX
j DoneChecking
CheckO:
bne $t1, $t3, CheckEmpty
jal PrintO
j DoneChecking
CheckEmpty:
jal PrintEmpty
j DoneChecking

DoneChecking:
add $t0, $t0, 4
j WhileLessThan9

EndWhileLessThan9:
#add $s0, $s0, -36
#add $s4, $s4, -36

la $a0, endl
li $v0, 4
syscall

jr $s3

j End

j PlayerTurn

PrintX:
la $a0, X
li $v0, 4
syscall
jr $ra
PrintO:
la $a0, O
li $v0, 4
syscall
jr $ra
PrintEmpty:
la $a0, Empty
li $v0, 4
syscall
jr $ra

XWinsProcedure:
la $a0, XWins
li $v0, 4
syscall
j End
OWinsProcedure:
la $a0, OWins
li $v0, 4
syscall
j End
TieProcedure:
la $a0, Tie
li $v0, 4
syscall
j End
End:
li $v0, 10
syscall


