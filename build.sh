
BUILD_STRING="cobc -O2 -x --debug -fstatic-call \
    ./src/cobordle.cbl \
    ./src/word_loader.cbl \
    ./src/run_game.cbl \
    ./src/display_info_text.cbl \
    ./src/display_remaining_letters.cbl \
    ./src/logger.cbl \
    -o ./bin/cobordle" 

echo 
echo "Building COBORDLE - COBOL Wordle"
echo "--------------------------------"
echo "By: Erik Eriksen"
echo "https://github.com/shamrice/cobordle"
echo 
echo $BUILD_STRING
echo     
$BUILD_STRING 
cp -v ./data/word.list ./bin 
echo 
echo 
echo Done.
echo 