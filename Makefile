CBL=cobc
CBLFLAGS=-Wall -O2 -fstatic-call --debug

CBL_MAIN=./src/cobordle.cbl 
CBL_SOURCES=$(shell find src -type f -name '*.cbl' | grep -v '${CBL_MAIN}')

all: build

build: cobordle

clean:
	rm -rfv bin

cobordle: ${CBL_MAIN} ${CBL_SOURCES} 
	mkdir -p -v ./bin/
	# cp -v ./data/word.list ./bin 
	${CBL} ${CBLFLAGS} -x -o ./bin/$@ $^
