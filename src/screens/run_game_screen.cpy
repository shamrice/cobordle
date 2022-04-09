      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-05
      * Last Modified: 2022-04-09
      * Purpose: Screen definition the main game background
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-run-game-background-screen blank screen. 
  
           05  s-title-line
               foreground-color cob-color-white highlight
               background-color cob-color-green.      
               10  line 1 column  1 from ws-empty-line.              
               10  line 1 column 28 value "COBOL WORDLE". 

           05  s-rules-text
               foreground-color cob-color-white 
               background-color cob-color-black.
               10  line 3 column 25
                   value "You have six tries to guess the word.".
               10  line 4 column 25
                   value "Green tiles indicate the letter is correct.".
               10  line 5 column 25
                   value "Yellow tiles indicate the letter is in the".
               10  line 6 column 25
                   value "word but in the wrong spot.".
               10  line 7 column 25 
              value "Gray tiles indicate the letter is not in the word".     

           05  s-cmds-text-1.
               10  foreground-color cob-color-black 
                   background-color cob-color-white
                   line 21 column 4
                   value " Enter ".

               10  foreground-color cob-color-white 
                   background-color cob-color-black 
                   line 21 column 12
                   value "Confirm Word Entry".
                    
               10  foreground-color cob-color-black
                   background-color cob-color-white
                   line 21 column 31
                   value " F12 ".

               10  foreground-color cob-color-white
                   background-color cob-color-black
                   line 21 column 37
                   value "Give up current puzzle".

               10  foreground-color cob-color-black
                   background-color cob-color-white
                   line 21 column 60
                   value " ESC ".

               10  foreground-color cob-color-white
                   background-color cob-color-black
                   line 21 column 66
                   value "Quit".       
                   