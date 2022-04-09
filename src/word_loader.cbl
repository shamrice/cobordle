      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-05
      * Last Modified: 2022-04-08
      * Purpose: Loads random word from the word file.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. word-loader.

       environment division.
       
       configuration section.

       repository. 
           function all intrinsic.          

       special-names.           

       input-output section.

           file-control.
               select optional fd-word-file 
               assign to dynamic ws-word-file-name 
               organization is line sequential.
           
       data division.
       file section. 

       fd  fd-word-file.
       01  f-word-entry              pic a(5).

       working-storage section.

       01  ws-word-file-name         constant as "word.list".

       01  ws-max-words              constant as 13000.
 
       01  ws-time-seed              pic 9(9) value zeros.
       01  ws-filler                 pic 9(9) value zeros.

       local-storage section.

       01  ls-eof-sw                 pic a value 'N'.
           88  ls-eof                value 'Y'.
           88  ls-not-eof            value 'N'.

      * 01  ls-word-list              pic a(5) occurs ws-max-words times.

       01  ls-word-idx               pic 9(5) comp value 0.
       01  ls-word-idx-disp          pic z(5).      

       01  ls-word-select            pic 9(5) comp value 1.
       01  ls-word-select-disp       pic z(5).

       linkage section.
       
       01  l-word-data.
           05  l-selected-word           pic a(5).
           05  l-word-list               pic a(5) 
                                         occurs ws-max-words times.

       procedure division using l-word-data.

       main-procedure.

           perform init-random-num-seed                

           open input fd-word-file 
                          
               perform until ls-eof
                                      
                   read fd-word-file
                   at end set ls-eof to true 
                   not at end  
                       if f-word-entry not = spaces then 
                           add 1 to ls-word-idx    
                           move upper-case(f-word-entry)
                           to l-word-list(ls-word-idx) 
                          *> display ls-word-list(ls-word-idx)                           
                       else 
                           call "logger" using 
                               "WORD-LOADER : Entry blank. skipping.."
                           end-call 
                       end-if 
                   end-read 

               end-perform

           close fd-word-file


           compute ls-word-select = random * ls-word-idx + 1 
           move l-word-list(ls-word-select)
               to l-selected-word

           move ls-word-idx to ls-word-idx-disp
           move ls-word-select to ls-word-select-disp

           call "logger" using concat(
               "WORD-LOADER : EXIT :: total words: " ls-word-idx-disp
               " selected idx: " ls-word-select-disp
               " selected word: " l-selected-word)
           end-call 
           

           goback.


      *> Inits the random number generator with seed from current time.
      *> If seed has already been set, do not re-init random number 
      *> generator as it will reset next RNG num.
       init-random-num-seed.
           if ws-time-seed = zeros then 
               accept ws-time-seed from time 
               compute ws-filler = random(ws-time-seed)

               call "logger" using concat(
                   "WORD-LOADER : Init  random number with seed: "
                   ws-time-seed)
               end-call 

           end-if 
           exit paragraph.

       end program word-loader.
       