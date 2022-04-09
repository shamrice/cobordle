      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-08
      * Last Modified: 2022-04-08
      * Purpose: Displays remaining letters, update values using parameters
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. display-remaining-letters.

       environment division.
       
       configuration section.
 
       repository. 
           function all intrinsic.          

       special-names.           
   
       data division.
  
       working-storage section.

       copy "screenio.cpy".


       01  ws-remaining-letters                 occurs 26 times
                                                indexed by ws-rem-idx.
           05  ws-remaining-letter              pic a. 
           05  ws-remaining-letter-bg-color     pic 9.
           05  ws-remamiing-letter-fg-color     pic 9. 
      
       01  ws-is-init-sw                        pic a value 'N'.
           88  ws-is-init                       value 'Y'.
           88  ws-is-not-init                   value 'N'.

       local-storage section.

       01  ls-temp-pos.
           05  ls-temp-y                        pic 99.
           05  ls-temp-x                        pic 99.

       linkage section.
                                 *> comp allows raw numeric to be passed
       01  l-letter-to-update                   pic x.                                 
       01  l-new-bg-color                       pic 9 comp.       
       
    
       procedure division.

       main-procedure.           

           if ws-is-not-init then 
               perform init-remaining-letters       
           end-if 
           
           move 10 to ls-temp-y 
           move 25 to ls-temp-x

           perform varying ws-rem-idx from 1 by 1 until ws-rem-idx > 26
               
               if ws-remaining-letter-bg-color(ws-rem-idx) 
               = cob-color-black then 
                   display 
                       ws-remaining-letter(ws-rem-idx) 
                       foreground-color 
                           ws-remamiing-letter-fg-color(ws-rem-idx)
                       background-color 
                           ws-remaining-letter-bg-color(ws-rem-idx)
                       at ls-temp-pos
                   end-display 
               else 
                   display 
                       ws-remaining-letter(ws-rem-idx) 
                       foreground-color 
                           ws-remamiing-letter-fg-color(ws-rem-idx)
                           highlight 
                       background-color 
                           ws-remaining-letter-bg-color(ws-rem-idx)
                       at ls-temp-pos
                   end-display 
               end-if 

               add 2 to ls-temp-x 

           end-perform 

           goback.


       init-remaining-letters. 

           perform varying ws-rem-idx from 1 by 1 until ws-rem-idx > 26 
               move cob-color-white 
                   to ws-remamiing-letter-fg-color(ws-rem-idx)

               move cob-color-black 
                   to ws-remaining-letter-bg-color(ws-rem-idx) 
           end-perform 

           move 'A' to ws-remaining-letter(1)
           move 'B' to ws-remaining-letter(2)
           move 'C' to ws-remaining-letter(3)
           move 'D' to ws-remaining-letter(4)
           move 'E' to ws-remaining-letter(5)
           move 'F' to ws-remaining-letter(6)
           move 'G' to ws-remaining-letter(7)
           move 'H' to ws-remaining-letter(8)
           move 'I' to ws-remaining-letter(9)
           move 'J' to ws-remaining-letter(10)
           move 'K' to ws-remaining-letter(11)
           move 'L' to ws-remaining-letter(12)
           move 'M' to ws-remaining-letter(13)
           move 'N' to ws-remaining-letter(14)
           move 'O' to ws-remaining-letter(15)
           move 'P' to ws-remaining-letter(16)
           move 'Q' to ws-remaining-letter(17)
           move 'R' to ws-remaining-letter(18)
           move 'S' to ws-remaining-letter(19)
           move 'T' to ws-remaining-letter(20)
           move 'U' to ws-remaining-letter(21)
           move 'V' to ws-remaining-letter(22)
           move 'W' to ws-remaining-letter(23)
           move 'X' to ws-remaining-letter(24)
           move 'Y' to ws-remaining-letter(25)
           move 'Z' to ws-remaining-letter(26)  

           set ws-is-init to true 

           exit paragraph.



       entry "remaining-letters-reinit"
           set ws-is-not-init to true 
           goback.



       entry "update-remaining-letters"
           using l-new-bg-color l-letter-to-update           
             
           perform varying ws-rem-idx 
           from 1 by 1 until ws-rem-idx > 26
                   
               if ws-remaining-letter(ws-rem-idx) = l-letter-to-update 
               then 
               
                   if ws-remaining-letter-bg-color(ws-rem-idx) 
                   not = cob-color-green then 

                       move l-new-bg-color
                       to ws-remaining-letter-bg-color(ws-rem-idx)
                   
                      *>If new background black, remove word by setting
                      *>foreground to black as well.
                       if ws-remaining-letter-bg-color(ws-rem-idx) 
                       = cob-color-black then                        
                           move cob-color-black
                           to ws-remamiing-letter-fg-color(ws-rem-idx)                    
                       end-if                        
                   end-if 

                   call "logger" using concat(
                       "UPDATE-REMAINING-LETTERS : "
                       "Setting letter: " l-letter-to-update " to " 
                       ws-remaining-letter-bg-color(ws-rem-idx))
                   end-call 
                       
                   goback *> shortcut out of loop once found
               end-if 

           end-perform            

           goback. 

       end program display-remaining-letters.
