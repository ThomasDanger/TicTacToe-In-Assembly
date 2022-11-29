# :x: Tic-Tac-Toe In Assemby - First Draft :o:

`Written by Thomas Conner on 11/28/2022 in the passenger seat of a Nissan Rogue during
a bumpy trip from San Antonio to Richardson, TX (4-5 hours) while listening to his sister's
eighth-grade emo music playlist at max volume.`

## Introduction

This was the first draft I wrote of Tic-Tac-Toe in assembly. This was done as part
of a project for my computer architecture class and written in MIPS assembly language.
  
The goal of the project was to make a working Tic-Tac-Toe game in which a player could
play against a computer with no requirements on the CPU's moveset other than that it had 
one.
  
In its current state, the CPU plays each cell on a row before proceeding to the next and
the gameboard is a one dimensional array. This will hopefully be improved upon in further
updates with the end goal being the CPU uses the minmax algorithm  to always win or tie.
  
In its current state, even with its flaws, this program outperforms my peers' programs
with its rudimentary input validation, minimal errors (only type errors when a user enters 
a string instead or int, etc.), crude but understandable AI, and ability to allow the player 
to choose between Xs and Os by reading in an X or O character from the user.

Also, the code isn't pretty. Like it REALLY isn't pretty. There's like 2 comments in ~300 lines 
of code, There's random labels everywhere and some of the practices with procedures are really 
hacky. I only posted this to show the progression on this program.
  
## STEPS
  
### STARTUP
  Upon startup, the program will give you a welcome message with a a short instruction.
  This instruction reads:
  
     Welcome to Tic-Tac-Toe
     - Start by entering X or O to choose your gamepiece 
     - then, enter the position you would like to play for that turn 
     - The positions are shown below 
     - Good Luck! (You probably won't need it this AI is not very bright)

     [ 0 ] [ 1 ] [ 2 ]
     [ 3 ] [ 4 ] [ 5 ]
     [ 6 ] [ 7 ] [ 8 ]
     
Where the grid containing the numbers represents a table and the numbers
represent the position of a cell. This is also the index at which the element
will exist in the array that holds the game data. Though, this (while convenient)
is merely coincidental as, even when I had previously panned to implement a 2d array
to hold the game data, I had still planned to use this system when prompting the user 
to play. This game will also prompt the user to choose X's or O's. This is explained
in the next step
  
### CHOOSING GAMEPIECE (X'S OR O'S)
The program will prompt you to enter an X or an O to choose whether you would
like to play as X or O respectively. If you choose X, you will player first. If you
choose O, the computer wil play first.

    TYPE X OR O TO CHOOSE GAME PIECE: 

If you enter a character that is neither X nor O, the program will loop back and ask 
again for your selection.

    TYPE X OR O TO CHOOSE GAME PIECE: C
    INVALID CHARACTER | ENTER X OR O 
    X

Here, the user entered 'C' instead of X or O and the program asked again. Here, we do
see an unfortunate inconsistency with the UI. Ideally, the ivalid character message should
end with a colon and a space like the line before it instead of a new line.

### PLAYER MOVE
The Program will then prompt the user to enter the number of the cell the player would like
to place their piece (X or O) in. Keep in mind the number of the cell is as follows

     [ 0 ] [ 1 ] [ 2 ]
     [ 3 ] [ 4 ] [ 5 ]
     [ 6 ] [ 7 ] [ 8 ]

The expected output from the prompt will be as follows

     ENTER DESIRED POSITION: 7
     
The program will then show the array after printing the character

     [   ] [   ] [   ]
     [   ] [   ] [   ]
     [   ] [ X ] [   ]

Here the user entered 7, so an X is placed in the bottom-middle cell

### CPU MOVE
As perviously mentioned, the CPU's decision making is practically nonexistent.
The CPU will attempt to fill in the cells in order from 0 to 8. It will check
to make sure the cell is empty before attempting to place its piece in the cell

The only output will be the gameboard after the CPU's move

     [ O ] [   ] [   ]
     [   ] [   ] [   ]
     [   ] [ X ] [   ]
     
### WIN CONDITIONS
 To check for win conditions, it should be made known that X's are stored into the array
 as 1's, O's are stored into the array as -1's, and empty spaces are stored as 0. to check
 for a win, the program adds every element an a line together and checks if the sum equals
 -3 or 3. If it equals -3, O wins. If it equals 3, X wins.
 
     [ X ] [ O ] [ O ]
     [ X ] [   ] [   ]
     [ X ] [   ] [   ]
    X WINS
 
     [ O ] [ O ] [ O ]
     [ X ] [ X ] [   ]
     [   ] [   ] [ X ]
    O WINS
    
     [ X ] [ O ] [ O ]
     [   ] [ X ] [   ]
     [   ] [   ] [ X ]
    X WINS
 
### TIE
 To check for a tie, the program will read every element in the array to check if there are
 any 0s. If a zero is found, the check wil immediately cease. If the end of the array is reached,
 however, a tie will be declared.
 
     [ X ] [ X ] [ O ]
     [ O ] [ X ] [ X ]
     [ X ] [ O ] [ O ]
    TIE
    
## GOING FORWARD
Going forward, I plan to improve upon the CPU's decision-making by utilizing the minmax algorithm
to make it unbeatable. Perhaps I could even add difficulties to the CPU, making an CPU that will only
detect when a player is about to win and playing the piece there but otherwise using a pseudo-random 
number generator to play moves, giving players at least a hope of winning. I would also like to go back 
and make the code look prettier by adding comments, taking out registers I only used when debugging ($s4) 
and turning some of the pseudo-subroutines into actual subroutines. Then, I would like to improve upon the 
UI, making it more consistent and posssibly even adding an ASCII art title. 

Once I finish the MIPS version of this program, I plan to recreate this program in x86 assembly language
as well as possibly ARM.

Thank you for checking this little project out. I understand this isn't too hard to code (Especially 
not hard to code poorly), but I had a lot of fun on this and just wanted to show my work.

Thank you for  reading this far,
Thomas Conner
