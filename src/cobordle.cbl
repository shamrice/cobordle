      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-05
      * Last Modified: 2022-04-08
      * Purpose: COBOL implementation of the WORDLE game.      
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. cobordle.

       environment division.
        
       configuration section.

       repository. 
           function all intrinsic.          

       special-names.           

       input-output section.
           
       data division.

       working-storage section.

       copy "screenio.cpy".

       01  ws-max-words                           constant as 13000.

       01  ws-replay-sw                           pic a value 'Y'.
           88  ws-replay                          value 'Y'.
           88  ws-not-replay                      value 'N'.       

       01  ws-word-data.
           05  ws-current-word                    pic a(5).
           05  ws-world-list                      pic a(5) occurs 
                                                  ws-max-words times.

       01  ws-cheat-flag                          pic a value 'N'.

       01  ws-cmd-found                           pic 9 comp.

       01  ws-compiled-date                       pic x(21).
 
       01  ws-cmd-args                            pic x(2024).

       77  ws-play-again-prompt                   pic x(80) 
                                              value "Play again? [Y/N]".

       local-storage section.

       procedure division.

       main-procedure.
           
           move when-compiled to ws-compiled-date

           display "COBORDLE - COBOL Wordle" 
           display "---------------------------------" 
           display "By: Erik Eriksen"
           display "Web: https://github.com/shamrice/cobordle"
           display "Build date: " ws-compiled-date
           display space           

           accept ws-cmd-args from command-line
           perform parse-cmd-args


           perform until ws-not-replay
               call "word-loader" using ws-word-data

               if ws-current-word = spaces then 
                   display space blank screen 
                   display 
                       "Error loading word. Value returned was empty. "
                           at 0101
                       "Please make sure word.list file exists in the "
                           at 0201
                       "current directory." 
                           at 0301
                   end-display 
                   display "Exiting..." at 0501
                   call "logger" using 
                       "Failed to load next word. Forced exit."
                   end-call 
                   call "disable-logger"
                   stop run
               end-if 

               display space blank screen 

               call "run-game" using ws-word-data ws-cheat-flag               

               display 
                   ws-play-again-prompt 
                   foreground-color cob-color-white highlight 
                   background-color cob-color-blue                    
                   at 2001
               end-display 
               accept ws-replay-sw upper at 2019

           end-perform

           call "disable-logger"

           stop run.



       parse-cmd-args.

           if ws-cmd-args = spaces then 
               exit paragraph 
           end-if 

           move 0 to ws-cmd-found
           inspect ws-cmd-args tallying ws-cmd-found 
               for all "--help"
                   all "-h"

           if ws-cmd-found > 0 then
               display "Usage: cobordle [OPTION]..."
               display "Run COBORDLE game with indicated parameters."
               display space 
               display "--logging          enables logging file"
               display "-h --help          show this help"
               display space 
               stop run 
           end-if 

           move 0 to ws-cmd-found
           inspect ws-cmd-args tallying ws-cmd-found for all "--logging"
           if ws-cmd-found > 0 then
               display "Logging Enabled..." 
               call "enable-logger"
           end-if 

           move 0 to ws-cmd-found
           inspect ws-cmd-args tallying ws-cmd-found for all "--iddqd"
           if ws-cmd-found > 0 then
               display "Cheat mode enabled..." 
               move 'Y' to ws-cheat-flag
           end-if            

           display space 

           exit paragraph.

       end program cobordle.
       