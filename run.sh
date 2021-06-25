#!/bin/bash

if [[ ${#} != 1 ]]; then
    echo "Please enter the filename as an argument."
    echo "Example usage: ./run.sh tests/basic.java"
    exit 1
fi

mkdir -p build
mkdir -p bin
filename="${1}"
lex src/basic.l && mv lex.yy.c build/
yacc -d src/basic.y && mv y.tab.h include/ && mv y.tab.c build
gcc -I"./include" build/lex.yy.c build/y.tab.c src/symtab.c -o bin/a.out
./bin/a.out < "${filename}"

mv output.txt "${filename}.txt"
echo "Generated output containing symtab and type errors (if any) in ${filename}.txt"

