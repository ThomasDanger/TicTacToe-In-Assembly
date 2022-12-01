.data
Title: .asciiz "\n _________________      _________________         _________________      ___   ___\n/______  _______//     /______  _______//        /______  _______//      \\ \\\\ / //\n      / //                   / //                      / //               \\ \\/ //\n     / //  ())              / //                      / //                 \\  //\n    / //  __   ___         / // ____    ___          / // ____   ____      /  \\>___\n   / //  / /| / _\\\\ ____  / // /   \\\\  / _\\\\  ____  / // /   \\\\ / _ \\\\    / /\\  _ \\\\\n  / //  / // / //_ /__// / // / () || / //_  /__// / // / () /// ____\\\\  / /// / \\ \\\\\n / //__/_//__\\__//______/ //__\\___/||_\\__//_______/ //__\\___//_\\_____//_/ //( (   ) ))\n \\_______________________________________________________________________//  \\ \\_/ //\n                                                                              \\___//\n"
X: .asciiz " [ X ]"
O: .asciiz " [ O ]"
Empty: .asciiz " [   ]"
endl: .asciiz "\n"
XWins: .asciiz "PLAYER WINS"
OWins: .asciiz "CPU WINS"
Tie: .asciiz "TIE"
SpaceOccuppied: .asciiz "SPACE OCCUPIED | ENTER SELECTION AGAIN: "
InvalidChar: .asciiz "INVALID CHARACTER | ENTER X OR O\n"
InvalidPosition: .asciiz "PLEASE SELECT A POSITION 0-8: "
ChooseChar: .asciiz "TYPE X OR O TO CHOOSE GAME PIECE: "
Instruction: .asciiz "Welcome to Tic-Tac-Toe \n - Start by entering X or O to choose your gamepiece \n - then, enter the position you would like to play for that turn \n - The positions are shown below \n - Good Luck! (You probably won't need it this AI is not very bright)\n\n [ 0 ] [ 1 ] [ 2 ]\n [ 3 ] [ 4 ] [ 5 ]\n [ 6 ] [ 7 ] [ 8 ] \n"
EnterPosition: .asciiz "ENTER DESIRED POSITION: "

.text

#$s0 holds data for X
#$s1 holds data for O
li, $s0, 0

#Print ascii art title to screen
la $a0, Title
li $v0, 4
syscall

#Print instructions to screen
la $a0, Instruction
li $v0, 4
syscall



#Main Gameplay Loop-----------------------------------------
GameLoop:
jal PlayerTurn
jal PrintTable
#jal CheckEndConditions
jal CPUTurn
jal PrintTable
#jal CheckEndConditions
j GameLoop
#Main Gameplay Loop-----------------------------------------

End:
li $v0, 10
syscall

#-------------------------------FUNCTIONS BELOW------------------

#Player's turn
PlayerTurn:
la $a0, EnterPosition #Prompt user to enter desired position
li $v0, 4
syscall
li $v0, 5
syscall               #Read input and move to reg $t0
move $t0, $v0
blt $t0, 0, UserPositionInvalid #If input is < 0 -> invalid
bgt $t0, 8, UserPositionInvalid #If input is > 8 -> invalid
j UserPositionValid
UserPositionInvalid:
la $a0, InvalidPosition #Output error and loop back
li $v0, 4
syscall
j PlayerTurn
UserPositionValid:
li $t1, 2
sll $t0, $t0, 1
sllv $t1, $t1, $t0
and $t0, $t1, $s0
srl $t2, $t1, 1
and $t2, $t2, $s0
or $t0, $t0, $t2
beq $t0, 0, SpotfoundPlayer
la $a0, SpaceOccuppied #Space Occuppied
li $v0, 4
syscall
j PlayerTurn
SpotfoundPlayer:
add $s0, $s0, $t1
jr $ra

#Controls the CPU's Move
CPUTurn:
li $t0, 0
WhileSpotNotFound:
li $t1, 1
sll $t2, $t0, 1
sllv $t1, $t1, $t2
addi $t0, $t0, 1
sll $t2, $t1, 1
or $t2, $t1, $t2
and $t2, $t2, $s0
beq $t2, 0, SpotFound
j WhileSpotNotFound
SpotFound:
add $s0, $s0, $t1
move $s6, $t1
jr $ra

#Prints the current table to the screen
PrintTable:
li $t0, 0
For9:
li $t3, 3
div $t0, $t3
mfhi $t3
bne $t3, $0, NoEndl
la $a0, endl
li $v0, 4
syscall
NoEndl:
beq $t0, 18, EndFor9
li $t1, 3
sllv $t1, $t1, $t0
and $t2, $t1, $s0
srlv $t2, $t2, $t0
addi $t0, $t0, 2
bne $t2, 2, NotX
la $a0, X
li $v0, 4
syscall
j For9
NotX:
bne $t2, 1, NotO
la $a0, O
li $v0, 4
syscall
j For9
NotO:
la $a0, Empty
li $v0, 4
syscall
j For9
EndFor9:
jr $ra

#Checks for tie, wins
CheckEndConditions:
#Tie
or $t0, $s0, $s1
beq $t0, 511, PrintTie

#X Wins
#Horizontal
andi $t0, $s0, 448 		#Checks win condition 111 000 000
beq $t0, 448, PrintXWins
andi $t0, $s0, 56 #000 111 000
beq $t0, 56, PrintXWins
andi $t0, $s0, 7 #000 000 111
beq $t0, 7, PrintXWins
#Vertical
andi $t0, $s0, 292 #100 100 100
beq $t0, 292, PrintXWins
andi $t0, $s0, 146 #010 010 010
beq $t0, 146, PrintXWins
andi $t0, $s0, 73 #001 001 001
beq $t0, 73, PrintXWins
#Diagonal
andi $t0, $s0, 273 #100 010 001
beq $t0, 273, PrintXWins
andi $t0, $s0, 84 #001 010 100
beq $t0, 84, PrintXWins
jr $ra

#O Wins
#Horizontal
andi $t0, $s1, 448 #111 000 000
beq $t0, 448, PrintOWins
andi $t0, $s1, 56 #000 111 000
beq $t0, 56, PrintOWins
andi $t0, $s1, 7 #000 000 111
beq $t0, 7, PrintOWins
#Vertical
andi $t0, $s1, 292 #100 100 100
beq $t0, 292, PrintOWins
andi $t0, $s1, 146 #010 010 010
beq $t0, 146, PrintOWins
andi $t0, $s1, 73 #001 001 001
beq $t0, 73, PrintOWins
#Diagonal
andi $t0, $s1, 273 #100 010 001
beq $t0, 273, PrintOWins
andi $t0, $s1, 84 #001 010 100
beq $t0, 84, PrintOWins
jr $ra

#Prints "TIE" to screen
PrintTie:
la $a0, Tie
li $v0, 4
syscall
j End

#Prints "PLAYER WINS" to screen
PrintXWins:
la $a0, XWins
li $v0, 4
syscall
j End

#Prints "CPU WINS" to screen
PrintOWins:
la $a0, OWins
li $v0, 4
syscall
j End
