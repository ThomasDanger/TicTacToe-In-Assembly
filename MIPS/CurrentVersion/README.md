# :x: Tic-Tac-Toe In Assemby - Current Version :o:

`Pretty Much It`

      _________________      _________________         _________________      ___   ___
     /______  _______//     /______  _______//        /______  _______//      \ \\ / //
           / //                   / //                      / //               \ \/ //
          / //  ())              / //                      / //                 \  //
         / //  __   ___         / // ____    ___          / // ____   ____      /  \>___
        / //  / /| / _\\ ____  / // /   \\  / _\\  ____  / // /   \\ / _ \\    / /\  _ \\
       / //  / // / //_ /__// / // / () || / //_  /__// / // / () /// ____\\  / /// / \ \\
      / //__/_//__\__//______/ //__\___/||_\__//_______/ //__\___//_\_____//_/ //( (   ) ))
      \_______________________________________________________________________//  \ \_/ //
                                                                                   \___//

## Introduction

This program allows you to play tic-tac-toe against a computer. This is my most recent
tic-tac-toe in assembly program.

#### Background
This program started as a solution to my computer architecture project: make a Tic-Tac-Toe
game in which a player can play against a computer. That was it. The CPU's decision-making
could be as stupid as you'd like. You could have to manually enter the memory address
you would like to add you piece too. You could even make the user type in the ascii value
of an X or O to choose between the two.

In the first build of my assemby tic-tac-toe program, I used a 9 element array to hold
the data for every piece on the game board with a -1 representing an O and a 1 representing
an X. This build used 267 lines of code (with comments removed) and was fully functional 
(even included minor input validation). The CPU ws not smart. The CPU would fill in the cells
0-8 until a win or tie was detected.

In my second build of the game, I decided to use two bit strings to hold the data of the 
game board. To my surprise, this cut the size of my program to only 212 lines without removing 
comments. While new problems emerged and this version had a few less features than the previous 
version (notably not allowing a player to choose their character), it was clear to me that this 
new method was smaller, more readable, and likely faster than my previous version because it 
could rely on bitwise operations to check positions of pieces on the game board rether than 
having to pull from an array and interpret the data.

#### Current Build
This build of Tic-Tac-Toe has managed to store the game board into a bitstring. This means all 
of the pieces' positions were interpretted as a single 18-bit integer. MIPS uses 32 bits to 
represent every integer, so this really was more of a resourceful solution rather than a
wasteful one. In the current build, there is an unbeatable CPU. The CPU will always win.
Therefore, if you choose O's. You better play the center square. 

At first, this build was only 202 lines of code with no comments removed or newlines removed. It 
was clear to me that I had moved in the right direction by storing the game this way. However, 
this current build uses 452 lines of code. I think this is impressive. Since finishing this project, 
I have looked at other assembly tic-tac-toe programs to see where mine stands space-wise and 
performance-wise, and it appears I have fit this program into a smaller file than it took most to
write a two-player game. This would be very impressive if true because a two-player tic-tac-toe game 
could easily be written in 180-220 lines if I were to simply modify my existing code. In fact, I will 
probably create one just to prove this point.

Going into this project--I'm going to be honest--I hated assembly language. When I heard we 
would have to make a tic-tac-toe game in it as part of a project, I just about gagged. However, 
after finishing my first build of the tic-tac-toe game, I became obsessed with trying to improve 
upon my program. I created an ascii art title that I am still trying to improve upon. I began 
drafting new ways to store the positions of the X's and O's. I drafted new ways check the positions 
of game pieces. I covered my class notebooks with 1's and 0's and X's and O's. I was so obsessed. 
I came out of this project LOVING assembly language. Without any exaggeration, I think this project 
might have changed my life and the way I view programming as well as consider a career in embedded
software/firmware engineering and development.
  
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
represent the position of a cell. The data for the player's move will be 
stored at 2^(Position*2). This game will also prompt the user to choose 
X's or O's. This is explained in the next step.
  
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
In the current build, the CPU will win or tie every time. The CPU decision-making
process is as follows:

1. Check if CPU can win -> Play winning move
2. Check if Player can win -> Block Player
3. If Player plays corner -> Play Center
4. If Player has pieces on opposite corners -> Play edge
5. Play Corner
6. Fill in 0-8

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
 To check for a tie, the program performs a bitwise "and" operation between the register holding
 the bit string representing the gameboard and 87381 (010101010101010101). Performing this bitwise 
 "and" instruction yields a bit string representing the position of every O in the string. Then, 
 we shift this resultant string left once. Then, we perform a logical and between the gameboard 
 and 174762 (101010101010101010). This yields the position of every X in the array. Finally, we 
 use a bitwise "or" between the X position bit string and the O position bitstring (that is shifted
 left) and compare it to 174762 (101010101010101010). This tells us that every cell has been filled
 
     [ X ] [ X ] [ O ]
     [ O ] [ X ] [ X ]
     [ X ] [ O ] [ O ]
    TIE
    
In the above example we see
Cell:  8  7  6  5  4  3  2  1  0

      | O| O|X |X |X | O| O|X |X |
This could then be represented by the binary string  

      |01|01|10|10|10|01|01|10|10|
By performing the aformentioned operations we see

            010110101001011010      010110101001011010
      &     010101010101010101      101010101010101010
            __________________      __________________
      <<    010100000001010000      000010101000001010
            __________________      VVVVVVVVVVVVVVVVVV
            101000000010100000   &  000010101000001010 = 101010101010101010 = TIE

## GOING FORWARD
Going forward, I would like to minimize the file size as well as try to find more novel ways to
optimize the CPU's decision-making (finding a faster way to find the nearest open corner, edge,
etc.) A concrete goal of mine it to get the number of lines not including white space and comments
down to under 400 lines.

I also plan to recreate this program in x86 and ARM.

Thank you for reading this far,
Thomas Conner
