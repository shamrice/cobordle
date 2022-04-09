# COBORDLE
Wordle clone written in GnuCOBOL

**COBORDLE** reads in a ```word.list``` file in the same directory as the executable. This file is used as the list of valid words that can be guessed. It is also the list that is used to select the current puzzle's answer from. At the start of each round, a random word will be selected from the ```word.list``` file as answer. 

During the game, confirm your answer with the ```Enter``` button. ```ESC``` button quits and ```F12``` quits current puzzle and asks if you would like to start a new one.

I didn't include the word list in this repo as it can be found elsewhere online (if at a later date that's not the case, I'll upload one here as well). A good word list source can be found here: https://github.com/tabatkins/wordle-list Just save the file as ```word.list``` and put it in the same directory as your **COBORDLE** executable.

The ```word.list``` file is expected to contain a five letter word for each line in the file. The case of the word does not matter. Blank lines are ignored.

## To build:
To build, run ```./build.sh```

## Screenshots 
![Game play screen shot](https://i.imgur.com/L84ht57.png) 

## Video
Quick video of me fumbling through a puzzle attempt quickly: (Click to view on YouTube) 

[![Short demo](https://img.youtube.com/vi/iRQHZE5uqgM/0.jpg)](https://youtu.be/iRQHZE5uqgM)


