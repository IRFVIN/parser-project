#!/bin/bash


rm -r build
rm -r bin
mkdir build
mkdir bin
filename="${1}"
lex src/basic.l && mv lex.yy.c build/
yacc -d src/basic.y && mv y.tab.h include/ && mv y.tab.c build
gcc -I"./include" build/lex.yy.c build/y.tab.c src/symtab.c -o bin/a.out
./bin/a.out < "${filename}"

mv output.txt "${filename}.txt"
echo "Generated output containing symtab and type errors (if any) in ${filename}.txt"

