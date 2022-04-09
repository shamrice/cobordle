      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-05
      * Last Modified: 2022-04-08
      * Purpose: Runs the game using the word passed to it.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. run-game.

       environment division.
       
       configuration section.

       special-names.
           crt status is ws-crt-status.

       repository. 
           function all intrinsic.          

       special-names.           
   
       data division.
  
       working-storage section.

       copy "screenio.cpy".

       01  ws-max-words                           constant as 13000.

       01  ws-max-tries                           constant as 6.

       01  ws-crt-status.
           05  ws-crt-status-key-1                pic xx.
           05  ws-crt-status-key-2                pic xx.
             
       77  ws-empty-line                          pic x(80).
       77  ws-guess-mask                          pic x(18).
       

       local-storage section.

       01  ls-current-try.       
           05  ls-current-try-num                 pic 9 comp.           
           05  ls-current-word-attempt            pic a(5).
       
       01  ls-correct-letters                     pic 9 comp value 0.
       01  ls-letter-search-count                 pic 9 comp value 0.

       01  ls-word-found-sw                       pic a value 'N'.
           88  ls-word-found                      value 'Y'.
           88  ls-word-not-found                  value 'N'.

       01  ls-current-try-pos.
           05  ls-current-try-y                   pic 99.
           05  ls-current-try-x                   pic 99.

       01  ls-idx                                 pic 9 comp.
       01  ls-idx-2                               pic 9 comp.

       01  ls-puzzle-solved-sw                    pic a value 'P'.
           88  ls-puzzle-solved                   value 'Y'.
           88  ls-puzzle-not-solved               value 'N'.
           88  ls-puzzle-in-progress              value 'P'.

       linkage section.
       
       01  l-word-data.
           05  l-selected-word           pic a(5).
           05  l-word-list               pic a(5) 
                                         occurs ws-max-words times
                                         indexed by l-word-idx.

       01  l-cheat-flag                  pic a. 

       screen section.

       copy "./src/screens/run_game_screen.cpy".
       copy "./src/screens/run_game_current_try_screen.cpy".       


      *> Expected that l-selected-word will be sent here in uppercase.
       procedure division using l-word-data l-cheat-flag.

           set environment "COB_SCREEN_EXCEPTIONS" to 'Y'.
           set environment "COB_SCREEN_ESC"        to 'Y'.      
           set environment "COB_EXIT_WAIT"         to 'NO'.

       main-procedure.           
           
           display space blank screen 
           display s-run-game-background-screen 

           compute ls-current-try-y = ls-current-try-num + 3

      *>   Cheating... show solution
           if l-cheat-flag = 'Y' then 
               call "logger" using "RUN-GAME : CHEAT MODE IS ENABLED"
               display concat("Answer: " l-selected-word) at 1740
           end-if 

           call "remaining-letters-reinit"
           call "display-remaining-letters"

           perform until ls-puzzle-solved or ls-puzzle-not-solved                                                            

               accept s-run-game-current-try-screen 
               move upper-case(ls-current-word-attempt)
                   to ls-current-word-attempt

               evaluate ws-crt-status
                  
                   when COB-SCR-F12                       
                       set ls-puzzle-not-solved to true                        

                   when COB-SCR-ESC 
                       call "disable-logger"                                    
                       stop run 

      *>   DEBUG: QtTerminal treats ESC->F5 as ESC for some reason...
      *>            when other 
      *>             display ws-crt-status at 1640 

               end-evaluate  

               call "display-info-text" using 0 " "                            

               perform validate-word-is-valid
                   
               if ls-word-found then 
                   perform check-current-try

                   call "display-remaining-letters"

                   if ls-correct-letters = 5 then 
                       call "display-info-text" using 
                           cob-color-green
                           "CONGRATS! Puzzle solved!"
                       end-call 
                       set ls-puzzle-solved to true 
                   end-if 
                   add 1 to ls-current-try-num
                   add 2 to ls-current-try-y
               end-if 

               if ls-puzzle-in-progress and 
               ls-current-try-num >= ws-max-tries then                
                   set ls-puzzle-not-solved to true 
               end-if 

           end-perform 

           if ls-puzzle-not-solved then
               call "display-info-text" using 
                   cob-color-red 
                   concat("The word was: " l-selected-word)
               end-call 
           end-if 

           goback.


       validate-word-is-valid.
           
           set ls-word-not-found to true 

           if ls-current-word-attempt = spaces then 
               exit paragraph 
           end-if 

           perform varying l-word-idx from 1 by 1 
           until l-word-idx > ws-max-words

               if l-word-list(l-word-idx) = ls-current-word-attempt then 
                   set ls-word-found to true 
                   exit paragraph *> Shortcut return if found.
               end-if 
           end-perform 

           call "display-info-text" using 
               cob-color-red
               concat("Word not found in word list: " 
                   ls-current-word-attempt)
           end-call 

           exit paragraph.


       check-current-try.

           move 6 to ls-current-try-x
           move 0 to ls-correct-letters

      *>   Hack-ish way to cover up accepted attempted word.
           display 
               ws-guess-mask
               at ls-current-try-pos
           end-display          

           perform varying ls-idx from 1 by 1 until ls-idx > 5 

               move 0 to ls-letter-search-count

               inspect l-selected-word 
                   tallying ls-letter-search-count 
                   for all ls-current-word-attempt(ls-idx:1)                         
               
               if ls-letter-search-count = 0 then 
                   display       
                       ls-current-word-attempt(ls-idx:1)
                       background-color cob-color-white 
                       foreground-color cob-color-black
                       at ls-current-try-pos
                   end-display    
                   call "update-remaining-letters" using 
                       cob-color-black ls-current-word-attempt(ls-idx:1)      
                   end-call 
               else                    
                   perform varying ls-idx-2 
                   from 1 by 1 until ls-idx-2 > 5

                       if l-selected-word(ls-idx-2:1) = 
                       ls-current-word-attempt(ls-idx:1) then       

                           display       
                               ls-current-word-attempt(ls-idx:1)
                               background-color cob-color-yellow 
                               foreground-color cob-color-black
                               at ls-current-try-pos
                           end-display 

                           call "update-remaining-letters" using 
                               cob-color-yellow 
                               ls-current-word-attempt(ls-idx:1)      
                           end-call          
                       end-if 
                   end-perform 
               end-if 
      
               if ls-current-word-attempt(ls-idx:1) 
               = l-selected-word(ls-idx:1) then 
                   display       
                       ls-current-word-attempt(ls-idx:1)
                       background-color cob-color-green 
                       foreground-color cob-color-black
                       at ls-current-try-pos
                   end-display  

                   call "update-remaining-letters" using 
                       cob-color-green 
                       ls-current-word-attempt(ls-idx:1)      
                   end-call 

                   add 1 to ls-correct-letters               
               end-if 
                
               add 2 to ls-current-try-x

           end-perform 

           exit paragraph.
    

       end program run-game.
