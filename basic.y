%{
// ordinary C declarations
#include <stdio.h>

// to get rid of "implicit declaration" warnings
void yyerror(const char *str) {
    fprintf(stderr,"error: %s\n",str);
}
int yylex();
int yywrap() {
        return 1;
}
%}

%token ID INTEGER REAL BASIC
%token ABSTRACT CONTINUE FOR NEW SWITCH ASSERT DEFAULT GOTO PACKAGE SYNCHRONIZED DO IF PRIVATE THIS BREAK IMPLEMENTS PROTECTED THROW ELSE IMPORT PUBLIC THROWS CASE ENUM INSTANCEOF RETURN TRANSIENT CATCH EXTENDS TRY FINAL INTERFACE STATIC CLASS FINALLY STRICTFP VOLATILE CONST NATIVE SUPER WHILE

%%

program :
    block   {printf("Valid program!\n"); }
    ;
block :
    '{' decls stmts '}'
    ;
decls :
    decls decl
    | /* empty */
    ;
decl :
    type ID ';'
    ;
type :
    type '[' INTEGER ']'
    | BASIC
    ;

stmts :
    stmts stmt
    | /* empty */
    ;

stmt :
    ID '=' expr ';'
    | ID '=' NEW type ';'
    | ID '[' INTEGER ']' '=' expr ';'
    ;
expr :
    expr '+' term
    | expr '-' term
    | term
    ;
term :
    term '*' factor
    | term '/' factor
    | factor
    ;
factor :
    '(' expr ')'
    | ID
    | INTEGER
    | REAL
    ;
    
%%

int main() {
    yyparse();
}

