.data
PlayerChar: .space 3
Title: .asciiz "\n _________________      _________________         _________________      ___   ___\n/______  _______//     /______  _______//        /______  _______//      \\ \\\\ / //\n      / //                   / //                      / //               \\ \\/ //\n     / //  ())              / //                      / //                 \\  //\n    / //  __   ___         / // ____    ___          / // ____   ____      /  \\>___\n   / //  / /| / _\\\\ ____  / // /   \\\\  / _\\\\  ____  / // /   \\\\ / _ \\\\    / /\\  _ \\\\\n  / //  / // / //_ /__// / // / () || / //_  /__// / // / () /// ____\\\\  / /// / \\ \\\\\n / //__/_//__\\__//______/ //__\\___/||_\\__//_______/ //__\\___//_\\_____//_/ //( (   ) ))\n \\_______________________________________________________________________//  \\ \\_/ //\n                                                                              \\___//\n"
X: .asciiz " [ X ]"
O: .asciiz " [ O ]"
Empty: .asciiz " [   ]"
endl: .asciiz "\n"
PlayerWins: .asciiz "PLAYER WINS"
CPUWins: .asciiz "CPU WINS"
Tie: .asciiz "TIE"
SpaceOccuppied: .asciiz "SPACE OCCUPIED | ENTER SELECTION AGAIN\n"
InvalidChar: .asciiz "INVALID CHARACTER | ENTER X OR O\n"
InvalidPosition: .asciiz "PLEASE SELECT A POSITION 0-8:"
ChooseChar: .asciiz "TYPE X OR O TO CHOOSE GAME PIECE: "
Instruction: .asciiz "Welcome to Tic-Tac-Toe \n - Start by entering X or O to choose your gamepiece \n - then, enter the position you would like to play for that turn \n - The positions are shown below \n - Good Luck! (You probably won't need it this AI is not very bright)\n\n [ 0 ] [ 1 ] [ 2 ]\n [ 3 ] [ 4 ] [ 5 ]\n [ 6 ] [ 7 ] [ 8 ] \n"
EnterPosition: .asciiz "ENTER DESIRED POSITION: "

.text
#						Cell:	8  7  6  5  4  3  2  1  0
#All X, O positions stored in integer string 	ex: 	XO XO XO XO XO XO XO XO XO
#							01 10 00 10 01 00 00 10 01
						
#							[ O ] [ X ] [   ]
#							[   ] [ O ] [ X ]
#							[   ] [ X ] [ O ]
li, $s0, 0

#Print ascii art title to screen
la $a0, Title
li $v0, 4
syscall

#Print instructions to screen
la $a0, Instruction
li $v0, 4
syscall

#Prompt user for X or O
PromptForChar:
la $a0, ChooseChar
li $v0, 4
syscall

#Read in the user-entered character and store it to PlayerChar
add $sp, $sp, -4
move $a0, $sp
li $a1, 3	    #Size 3 because [char][\n][null terminator]
li $v0, 8
syscall

lbu $t0, 0($sp)
beq $t0, 88, ChoseX #Check if user chose X
beq $t0, 79, ChoseO #Check if user chose O 

la $a0, InvalidChar #If user did not choose X or O -> error message + loops back
li $v0, 4
syscall
j PromptForChar

ChoseO:
la $s1, O
la $s2, X
j CPUStart

ChoseX:
la $s1, X
la $s2, O

#Main Gameplay Loop-----------------------------------------
GameLoop:
#jal CheckBestMove
jal PlayerTurn
jal PrintTable
jal CheckEndConditions
CPUStart:
jal CPUTurn
jal PrintTable
jal CheckEndConditions
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
CheckBestMove:
#Check if CPU can Win
andi $t0, $s0, 86016	# 01 01 01 | 00 00 00 | 00 00 00
xori $t0, $t0, 86016
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckRow2CPU
beq $t0, 65536, returnFromCheckNearWins	# 01 00 00 | 00 00 00 | 00 00 00
beq $t0, 16384, returnFromCheckNearWins	# 00 01 00 | 00 00 00 | 00 00 00
beq $t0, 4096, returnFromCheckNearWins		# 00 00 01 | 00 00 00 | 00 00 00
CheckRow2CPU:
andi $t0, $s0, 1344	# 00 00 00 | 01 01 01 | 00 00 00
xori $t0, $t0, 1344
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckRow3CPU
beq $t0, 1024, returnFromCheckNearWins		# 00 00 00 | 01 00 00 | 00 00 00
beq $t0, 256, returnFromCheckNearWins		# 00 00 00 | 00 01 00 | 00 00 00
beq $t0, 64, returnFromCheckNearWins		# 00 00 00 | 00 00 01 | 00 00 00
CheckRow3CPU:
andi $t0, $s0, 21	# 00 00 00 | 00 00 00 | 01 01 01
xori $t0, $t0, 21
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckColumn1CPU
beq $t0, 16, returnFromCheckNearWins		# 00 00 00 | 00 00 00 | 01 00 00
beq $t0, 4, returnFromCheckNearWins		# 00 00 00 | 00 00 00 | 00 01 00
beq $t0, 1, returnFromCheckNearWins		# 00 00 00 | 00 00 00 | 00 00 01
CheckColumn1CPU:
andi $t0, $s0, 66576	# 01 00 00 | 01 00 00 | 01 00 00
xori $t0, $t0, 66576
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckColumn2CPU
beq $t0, 65536, returnFromCheckNearWins
beq $t0, 1024, returnFromCheckNearWins
beq $t0, 16, returnFromCheckNearWins
CheckColumn2CPU:
andi $t0, $s0, 16644	# 00 01 00 | 00 01 00 | 00 01 00
xori $t0, $t0, 16644
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckColumn3CPU
beq $t0, 16384, returnFromCheckNearWins
beq $t0, 260, returnFromCheckNearWins
beq $t0, 4, returnFromCheckNearWins
CheckColumn3CPU:
andi $t0, $s0, 4161	# 00 00 01 | 00 00 01 | 00 00 01
xori $t0, $t0, 4161
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckDiagonal1CPU
beq $t0, 4096, returnFromCheckNearWins
beq $t0, 64, returnFromCheckNearWins
beq $t0, 1, returnFromCheckNearWins
CheckDiagonal1CPU:
move $s5, $s0
andi $t0, $s0, 65793	# 01 00 00 | 00 01 00 | 00 00 01
xori $t0, $t0, 65793
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckDiagonal2CPU
beq $t0, 65536, returnFromCheckNearWins
beq $t0, 256, returnFromCheckNearWins
beq $t0, 1, returnFromCheckNearWins
CheckDiagonal2CPU:
andi $t0, $s0, 4368	# 00 00 01 | 00 01 00 | 01 00 00
xori $t0, $t0, 4368
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CPUDone
beq $t0, 4096, returnFromCheckNearWins
beq $t0, 256, returnFromCheckNearWins
beq $t0, 16, returnFromCheckNearWins
CPUDone:
#Check if CPU can lose
andi $t0, $s0, 172032	# 10 10 10 | 00 00 00 | 00 00 00
xori $t0, $t0, 172032
srl $t0, $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckRow2Player
beq $t0, 65536, returnFromCheckNearWins
beq $t0, 16384, returnFromCheckNearWins
beq $t0, 4096, returnFromCheckNearWins
CheckRow2Player:
andi $t0, $s0, 2688	# 00 00 00 | 10 10 10 | 00 00 00
xori $t0, $t0, 2688
srl $t0 $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckRow3Player
beq $t0, 1024, returnFromCheckNearWins
beq $t0, 256, returnFromCheckNearWins
beq $t0, 64, returnFromCheckNearWins
CheckRow3Player:
andi $t0, $s0, 42	# 00 00 00 | 00 00 00 | 10 10 10
xori $t0, $t0, 42
srl $t0 $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckColumn1Player
beq $t0, 16, returnFromCheckNearWins
beq $t0, 4, returnFromCheckNearWins
beq $t0, 1, returnFromCheckNearWins

#VVVV LEFT OFF HERE VVVV 
#Finish below
CheckColumn1Player:
andi $t0, $s0, 133152	# 10 00 00 | 10 00 00 | 10 00 00
xori $t0, $t0, 133152
srl $t0 $t0, 1
sll $t1, $t0, 1
#Changed piece V
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckColumn2Player
beq $t0, 65536, returnFromCheckNearWins
beq $t0, 1024, returnFromCheckNearWins
beq $t0, 16, returnFromCheckNearWins
CheckColumn2Player:
andi $t0, $s0, 33288	# 00 10 00 | 00 10 00 | 00 10 00
xori $t0, $t0, 33288
srl $t0 $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckColumn3Player
beq $t0, 16384, returnFromCheckNearWins
beq $t0, 256, returnFromCheckNearWins
beq $t0, 4, returnFromCheckNearWins
CheckColumn3Player:
andi $t0, $s0, 8322	# 00 00 10 | 00 00 10 | 00 00 10
xori $t0, $t0, 8322
srl $t0 $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckDiagonal1Player
beq $t0, 4096, returnFromCheckNearWins
beq $t0, 64, returnFromCheckNearWins
beq $t0, 1, returnFromCheckNearWins
CheckDiagonal1Player:
andi $t0, $s0, 131586	# 10 00 00 | 00 10 00 | 00 00 10
xori $t0, $t0, 131586
srl $t0 $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, CheckDiagonal2Player
beq $t0, 65536, returnFromCheckNearWins
beq $t0, 256, returnFromCheckNearWins
beq $t0, 1, returnFromCheckNearWins
CheckDiagonal2Player:
andi $t0, $s0, 8736	# 00 00 10 | 00 10 00 | 10 00 00
xori $t0, $t0, 8736
srl $t0 $t0, 1
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $t1, $s0
bne $t1, 0, GoToCenterIfPlayerOnCorner
beq $t0, 4096, returnFromCheckNearWins
beq $t0, 256, returnFromCheckNearWins
beq $t0, 16, returnFromCheckNearWins

GoToCenterIfPlayerOnCorner:
andi $t1, $s0, 	139298		#10 00 10 00 00 00 10 00 10
andi $t0, $s0, 	768		#00 00 00 00 11 00 00 00 00
beq $t1, 0, IfPlayerOnOppCornerFindEdge
bne $t0, 0, IfPlayerOnOppCornerFindEdge
li $t0, 256			#00 00 00 00 01 00 00 00 00
j returnFromCheckNearWins

IfPlayerOnOppCornerFindEdge:
andi $t1, $s0, 131074
beq $t1, 131074, FindEdge
andi $t1, $s0, 8224
beq $t1, 8224, FindEdge
j FindOpenCorner

FindEdge:
li $t0, 16384
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $s0, $t0
beq $t1, 0, returnFromCheckNearWins
li $t0, 1024
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $s0, $t0
beq $t1, 0, returnFromCheckNearWins
li $t0, 64
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $s0, $t0
beq $t1, 0, returnFromCheckNearWins
li $t0, 4
sll $t1, $t0, 1
or $t1, $t1, $t0 
and $t1, $s0, $t0
beq $t1, 0, returnFromCheckNearWins

FindOpenCorner:
andi $t1, $s0, 	207		#00 00 00 00 00 11 00 11 11
bne $t1, 0, CheckTopRight
li $t0, 1
j returnFromCheckNearWins
CheckTopRight:
andi $t1, $s0, 	3132		#00 00 00 11 00 00 11 11 00
bne $t1, 0, CheckBottomLeft
li $t0, 16			#00 00 00 00 00 00 01 00 00
j returnFromCheckNearWins
CheckBottomLeft:
andi $t1, $s0, 	127168		#00 11 11 00 00 11 00 00 00
bne $t1, 0, CheckBottomRight
li $t0, 4096			#00 00 01 00 00 00 00 00 00
j returnFromCheckNearWins
CheckBottomRight:
andi $t1, $s0, 	248832		#11 11 00 11 00 00 00 00 00
bne $t1, 0, FillIn
li $t0, 65536			#01 00 00 00 00 00 00 00 00
j returnFromCheckNearWins

FillIn:
li $t1, 0
WhileSpotNotFound:
li $t0, 1
sll $t2, $t1, 1
sllv $t0, $t0, $t2
addi $t1, $t1, 1
sll $t2, $t0,  1
or $t2, $t0, $t2
and $t2, $t2, $s0
beq $t2, 0, returnFromCheckNearWins
j WhileSpotNotFound
returnFromCheckNearWins:
add $s0, $s0, $t0
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
move $a0, $s1
li $v0, 4
syscall
j For9
NotX:
bne $t2, 1, NotO
move $a0, $s2
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

#Checks for wins, tie
CheckEndConditions:
#Horizontal
andi $t0, $s0, 258048 		# 11 11 11 | 00 00 00 | 00 00 00
beq $t0, 172032, PrintPlayerWins
beq $t0, 86016, PrintCPUWins
andi $t0, $s0, 4032 		# 00 00 00 | 11 11 11 | 00 00 00
beq $t0, 2688, PrintPlayerWins
beq $t0, 1344, PrintCPUWins
andi $t0, $s0, 63		# 00 00 00 | 00 00 00 | 11 11 11
beq $t0, 42, PrintPlayerWins
beq $t0, 21, PrintCPUWins
#Vertical
andi $t0, $s0, 199728		# 11 00 00 | 11 00 00 | 11 00 00
beq $t0, 133152, PrintPlayerWins
beq $t0, 66576, PrintCPUWins
andi $t0, $s0, 49932 		# 00 11 00 | 00 11 00 | 00 11 00
beq $t0, 33288, PrintPlayerWins
beq $t0, 16644, PrintCPUWins
andi $t0, $s0, 12483 		# 00 00 11 | 00 00 11 | 00 00 11
beq $t0, 8322, PrintPlayerWins
beq $t0, 4161, PrintCPUWins
#Diagonal
andi $t0, $s0, 197379 		#11 00 00 | 00 11 00 | 00 00 11
beq $t0, 131586, PrintPlayerWins
beq $t0, 65793, PrintCPUWins
andi $t0, $s0, 13104 		#00 00 11 | 00 11 00 | 11 00 00
beq $t0, 8736, PrintPlayerWins
beq $t0, 4368, PrintCPUWins

#Tie
andi $t1, $s0, 87381 #Find o positions
sll $t1, $t1, 1
andi $t0, $s0, 174762 #find x positions
or $t0, $t0, $t1
beq $t0, 174762, PrintTie

jr $ra

#Prints "TIE" to screen
PrintTie:
la $a0, Tie
li $v0, 4
syscall
j End

#Prints "PLAYER WINS" to screen
PrintPlayerWins:
la $a0, PlayerWins
li $v0, 4
syscall
j End

#Prints "CPU WINS" to screen
PrintCPUWins:
la $a0, CPUWins
li $v0, 4
syscall
j End
