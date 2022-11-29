.data
table: .word 0,0,0,0,0,0,0,0,0
Title: .asciiz "\n _________________      _________________         _________________      ___   ___\n/______  _______//     /______  _______//        /______  _______//      \\ \\\\ / //\n      / //                   / //                      / //               \\ \\/ //\n     / //  ())              / //                      / //                 \\  //\n    / //  __   ___         / // ____    ___          / // ____   ____      /  \\>___\n   / //  / /| / _\\\\ ____  / // /   \\\\  / _\\\\  ____  / // /   \\\\ / _ \\\\    / /\\  _ \\\\\n  / //  / // / //_ /__// / // / () || / //_  /__// / // / () /// ____\\\\  / /// / \\ \\\\\n / //__/_//__\\__//______/ //__\\___/||_\\__//_______/ //__\\___//_\\_____//_/ //( (   ) ))\n \\_______________________________________________________________________//  \\ \\_/ //\n                                                                              \\___//\n"
X: .asciiz " [ X ]"
O: .asciiz " [ O ]"
Empty: .asciiz " [   ]"
endl: .asciiz "\n"
XWins: .asciiz "X WINS"
OWins: .asciiz "O WINS"
Tie: .asciiz "TIE"
SpaceOccuppied: .asciiz "SPACE OCCUPIED | ENTER SELECTION AGAIN: "
InvalidChar: .asciiz "INVALID CHARACTER | ENTER X OR O\n"
InvalidPosition: .asciiz "PLEASE SELECT A POSITION 0-8: "
ChooseChar: .asciiz "TYPE X OR O TO CHOOSE GAME PIECE: "
PlayerChar: .space 3
Instruction: .asciiz "Welcome to Tic-Tac-Toe \n - Start by entering X or O to choose your gamepiece \n - then, enter the position you would like to play for that turn \n - The positions are shown below \n - Good Luck! (You probably won't need it this AI is not very bright)\n\n [ 0 ] [ 1 ] [ 2 ]\n [ 3 ] [ 4 ] [ 5 ]\n [ 6 ] [ 7 ] [ 8 ] \n"
EnterPosition: .asciiz "ENTER DESIRED POSITION: "

.text

#SET UP PRIOR TO GAMEPLAY LOOP------------------------------------

#s0 holds array adress
la $s0, table

#Print ascii art title to screen
la $a0, Title
li $v0, 4
syscall

#Print instructions to screen
la $a0, Instruction
li $v0, 4
syscall

#Ask user to enter X or O to choose
PromptForChar:
la $a0, ChooseChar
li $v0, 4
syscall

#Read in the user-entered character and store it to PlayerChar
la $a0, PlayerChar
li $a1, 3	    #Size 3 because [char][\n][null terminator]
li $v0, 8
syscall

la $t0, PlayerChar #Get first character of input string
lbu $t0, 0($t0)


bne $t0, 79, NotO #Check if user chose O 
li $s1, -1
li $s2, 1
#jump to ChoseO in main gameplay loop
j CPUTurn

NotO:
bne $t0, 88, NotOorX #Check if user chose X 
li $s1, 1
li $s2, -1
#jump to choseX in main gameplay loop
j PlayerTurn

NotOorX:
la $a0, InvalidChar #If user did not choose X or O -> error message + loops back
li $v0, 4
syscall
j PromptForChar

#MAIN LOOP GOES HERE ---------------------------------------------
#ChoseX:
# playerTurn()
# printTable()
# didEnd = checkEndConditions()
# if DidEnd !=0 -> 	if DidEnd == 1 -> O Wins
#			if DidEnd == 2 -> X Wins
#			if DidEnd == 3 -> Tie
#			branch to end
#ChoseO:
# CPUTurn()
# printTable()
# didEnd = checkEndConditions()
# ifDidEnd !=0 -> 	ifDidEnd == 1 -> O Wins
#			ifDidEnd == 2 -> Tie
#			ifDidEnd == 3 -> X Wins
#			branch to end
#j to top of main loop

#End:

#------------------------------------------------------------------

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

UserPositionValid: #If user position was previously deemed valid -> check if space is vacant
sll $t0, $t0, 2
add $s0, $s0, $t0
#add $s4, $s4, $t0
lw $t2, 0($s0)
beq $t2, 0, SpaceVacant #If space is vacant -> jump to SpaceVacant | Otherwise, output error and loop back (after resetting array address
sub $s0, $s0, $t0
la $a0, SpaceOccuppied
li $v0, 4
syscall
j PlayerTurn

SpaceVacant: #If space was vacant -> insert gamepiece into that element of the array
sw $s1, 0($s0)
sub $s0, $s0, $t0
#sub $s4, $s4, $t0
li $t0, 0
jal PrintTable
jal CheckEndConditions

CPUTurn:
li $t1, 0
whileNotVacant:           #While a vacant space is not found -> check next box in array
add $s0, $s0, $t1
#add $s4, $s4, $t1
lw $t2, 0($s0)

beq  $t2, $0, EndWhileNotVacant #if vacant spot found -> end loop
sub $s0, $s0, $t1
#sub $s4, $s4, $t1
addi $t1, $t1, 4
j whileNotVacant
EndWhileNotVacant: #Insert element at vacant spot
sw $s2, 0($s0)
sub $s0, $s0, $t1
#sub $s4, $s4, $t1
jal PrintTable
jal CheckEndConditions
j PlayerTurn

#PlayPiece($s1/$s2 in $v0, $v1 ) takes integer -1 or 1 and returns 1 or 0 in $a0 (1 if it could play the piece (vacant), 0 if not(occuppied)

#CheckNearWins($s1/$s2 in $v0, $v1) returns vacant position in a near win

CheckEndConditions: 
#CHECK HORIZONTALS
#Row 1:
li $t0, 0
lw $t1, 0($s0)
add $t0, $t0, $t1
lw $t1, 4($s0)
add $t0, $t0, $t1
lw $t1, 8($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure
#Row 2:
li $t0, 0
lw $t1, 12($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 20($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure
#Row 3:
li $t0, 0
lw $t1,24($s0)
add $t0, $t0, $t1
lw $t1, 28($s0)
add $t0, $t0, $t1
lw $t1, 32($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

#CHECK VERTICALS
#Column 1:
li $t0, 0
lw $t1, 0($s0)
add $t0, $t0, $t1
lw $t1, 12($s0)
add $t0, $t0, $t1
lw $t1, 24($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure
#Column 2:
li $t0, 0
lw $t1, 4($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 28($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure
#Column 3:
li $t0, 0
lw $t1,8($s0)
add $t0, $t0, $t1
lw $t1, 20($s0)
add $t0, $t0, $t1
lw $t1, 32($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

#CHECK DIAGONALS
#Top left to bottom right:
li $t0, 0
lw $t1, 0($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 32($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure
#Top right to bottom left:
li $t0, 0
lw $t1, 8($s0)
add $t0, $t0, $t1
lw $t1, 16($s0)
add $t0, $t0, $t1
lw $t1, 24($s0)
add $t0, $t0, $t1
beq $t0, 3, XWinsProcedure
beq $t0, -3, OWinsProcedure

#CHECK FOR TIE (Check for a zero in the array. If no zeros -> no vacancies -> tie)
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

PrintTable: #Prints every element in array
li $t0, 0
li $t4, 36
WhileLessThan9:
bge $t0, $t4, EndWhileLessThan9
li $t5, 3
div $t0, $t5
mfhi $t5
bne $t5, $0, NoEndl #if position%3 is not equal to 0 -> do not add end line | Otherwise do add end line
la $a0, endl
li $v0, 4
syscall
NoEndl:			#If no end line needed (or end line already added) -> print element
add $s0, $s0, $t0
#add $s4, $s4, $t0
lw $t1, 0($s0)
sub $s0, $s0, $t0
#sub $s4, $s4, $t0
li $t2, 1
li $t3, -1

CheckX:			#If space is an X -> print X
bne $t1, $t2, CheckO
#Print X
la $a0, X
li $v0, 4
syscall
j DoneChecking

CheckO:			#If space is an O -> print O
bne $t1, $t3, CheckEmpty
#Print O
la $a0, O
li $v0, 4
syscall
j DoneChecking

CheckEmpty:		#If space is empty -> print empty
#Print Empty
la $a0, Empty
li $v0, 4
syscall

DoneChecking:
add $t0, $t0, 4
j WhileLessThan9

EndWhileLessThan9:

la $a0, endl
li $v0, 4
syscall

jr $ra

#Change name to printXWins
XWinsProcedure: #X Wins the game, output message and proceed to terminate program
la $a0, XWins
li $v0, 4
syscall
j End

#Change name to printOWins
OWinsProcedure: #O Wins the game, output message and proceed to terminate program
la $a0, OWins
li $v0, 4
syscall
j End

#Change name to printTie
TieProcedure: #Tie game, output message and proceed to terminate program
la $a0, Tie
li $v0, 4
syscall
j End

End: #Terminate program
li $v0, 10
syscall
