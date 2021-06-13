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

%token ID INTEGER BASIC

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
    ;
    
%%

int main() {
    yyparse();
}

