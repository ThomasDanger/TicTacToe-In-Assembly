#First Draft

  This was the first fraft I wrote of Tic-Tac-Toe in assembly. This was done as part
  of a project for my computer architecture class.
  
  The goal of the project was to make a working Tic-Tac-Toe game in which a player could
  play against a computer with no requirements on the CPU's moveset other than that it had 
  one.
  
  In its current state, the CPU plays each cell on a row before proceeding to the next and
  the gameboard is a one dimensional array. This will hopefully be improved upon in further
  updates with the end goal being the CPU uses the minmax algorithm  to always win or tie.
  
  In its current state, even with its flaws, this program outperforms my peers' programs
  with its rudimentary input validation, crude but understandable AI, and ability to allow
  the player to choose between Xs and Os by reading in an X or O character from the user.
  
  STEPS-------------------------------------------------------------------------------------
  
  STARTUP
    Upon startup, the program will give you a welcome message with a a short instruction.
    This instruction reads:
  
     `Welcome to Tic-Tac-Toe`
     `- Start by entering X or O to choose your gamepiece `
     `- then, enter the position you would like to play for that turn `
     `- The positions are shown below `
     `- Good Luck! (You probably won't need it this AI is not very bright)`

     `[ 0 ] [ 1 ] [ 2 ]`
     `[ 3 ] [ 4 ] [ 5 ]`
     `[ 6 ] [ 7 ] [ 8 ] `
  
  CHOOSING GAMEPIECE (X'S OR O'S)
    The program will prompt you to enter an X or an O to choose whether you would
    like to play as X or O respectively. If you choose X, you will player first. If you
    choose O, the computer wil play first.
