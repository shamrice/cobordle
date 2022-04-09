      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2022-04-08
      * Last Modified: 2022-04-08
      * Purpose: Displays info bar with values passed in linkage section
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. display-info-text.

       environment division.
       
       configuration section.

   
       repository. 
           function all intrinsic.          

       special-names.           
   
       data division.
  
       working-storage section.

       copy "screenio.cpy".


       local-storage section.

       01  ls-info-sreen-data.           
           05  ls-info-screen-bg-color            pic 9.
           05  ls-info-screen-text                pic x(80) value space.

       
       linkage section.
                                 *> comp allows raw numeric to be passed
       01  l-info-screen-bg-color                 pic 9 comp.
       01  l-info-screen-text                     pic x any length.
       
       screen section.

       copy "./src/screens/info_screen.cpy".
      
       procedure division using 
           l-info-screen-bg-color l-info-screen-text.

       main-procedure.           

           move l-info-screen-bg-color to ls-info-screen-bg-color
           move l-info-screen-text to ls-info-screen-text
           display s-info-screen 

           call "logger" using concat( 
               "INFO-SCREEN :: bg color: " ls-info-screen-bg-color
               " : text: " ls-info-screen-text) 
           end-call 

           goback.

       end program display-info-text.
