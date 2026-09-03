
export PATH := ./bin:$(PATH)

all:
	echo hello

honban:
	echo $(PATH)
	down_build.sh

test:
	#./bin/build.sh data/Wikipedia-20260708213825.xml
	build.sh data/Wikipedia-20260410193938.xml.bz2

clean:
	rm output/*
