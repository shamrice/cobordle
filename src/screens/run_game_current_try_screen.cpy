      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-05
      * Last Modified: 2022-04-08
      * Purpose: Screen definition the the current try
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-run-game-current-try-screen                                 
           foreground-color cob-color-white highlight 
           background-color cob-color-black.

           10  line ls-current-try-y column 6 
               pic a(5) using ls-current-word-attempt.
                   

               
                   
                   