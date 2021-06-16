lex basic.l 
yacc -yd basic.y 
gcc lex.yy.c y.tab.c
./a.out