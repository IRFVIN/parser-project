%{
// ordinary C declarations
#include <stdio.h>

#include "symtab.h"

int is_curr_symbol_sequence;
Symbol curr_symbol;
extern FILE* yyout;
// to get rid of "implicit declaration" warnings
void yyerror(const char *str) {
    fprintf(stderr,"error: %s\n",str);
}
int yylex();
int yywrap() {
    return 1;
}
%}

%union {
    char *stringValue;
}

%token <stringValue> ID BASIC SEQUENCE_TYPE
%token INTEGER REAL
%token ABSTRACT CONTINUE FOR NEW SWITCH ASSERT DEFAULT GOTO PACKAGE SYNCHRONIZED DO IF PRIVATE THIS BREAK IMPLEMENTS PROTECTED THROW ELSE IMPORT PUBLIC THROWS CASE ENUM INSTANCEOF RETURN TRANSIENT CATCH EXTENDS TRY FINAL INTERFACE STATIC CLASS FINALLY STRICTFP VOLATILE CONST NATIVE SUPER WHILE

%type<stringValue> type basic array_type sequence_type decl assignment expr term factor

%%

program :
    block   {printf("Syntactically valid program!\n"); }
    ;
block :
    '{' decls stmts '}'
    ;
decls :
    decls decl
    | /* empty */
    ;
decl :
    type ID assignment ';' {
        fprintf(yyout, "\ntype: %s\nid: %s\nis_sequence: %d\n", $1, $2, is_curr_symbol_sequence);
        
        Symbol curr_symbol = {strdup($2), strdup($1), ID, is_curr_symbol_sequence};
        displaySymbol(curr_symbol);
        
        if (getSymtabEntryIdx(curr_symbol.name) != -1) {
            fprintf(yyout, "ERROR: Redeclaration of symbol %s\n", $2);
        } else {
            insertInSymtab(curr_symbol);
            // and check type compatibility
            if ($3 != NULL && strcmp($1, $3) != 0) {
                fprintf(yyout, "ERROR: Incompatible types %s and %s\n", $1, $3);
            } else {
                fprintf(yyout, "type compatibility: ok\n");
            }
        }

        fprintf(yyout, "Number of symbols declared so far: %d\n", num_symbols);
    }
    ;

assignment :
    '=' expr { $$ = $2; }
    | '=' NEW BASIC '[' INTEGER ']' { $$ = $3; }
    | '=' NEW sequence_type '(' ')' { $$ = $3; }
    | {$$ = NULL;}
    ;

type : 
    sequence_type {is_curr_symbol_sequence = 1;}
    | array_type {is_curr_symbol_sequence = 1;}
    | basic {is_curr_symbol_sequence = 0;}
    ;

basic :
    BASIC 
    ;

array_type :
    BASIC '[' ']'
    ;

sequence_type :
    SEQUENCE_TYPE '<' BASIC '>' {$$ = $3;}
    ;


stmts :
    stmts stmt
    | /* empty */
    ;

stmt :
    ID assignment ';' {
        // check if ID is present in the symbol table
        int idx = getSymtabEntryIdx($1);
        if (idx == -1) {
            fprintf(yyout, "\nERROR: Symbol %s is not declared.\n", $1);
        } else {
            // check type compatibility
            if ($2 != NULL && strcmp(symbols[idx].type, $2) != 0) {
                fprintf(yyout, "\nERROR: Incompatible types %s and %s\n", symbols[idx].type, $2);
            } 
        }
    }
    | ID '[' INTEGER ']' '=' expr ';' {
        // check if ID is present in the symbol table
        int idx = getSymtabEntryIdx($1);
        if (idx == -1) {
            fprintf(yyout, "ERROR: Symbol %s is not declared.\n", $1);
        } else {
            // check type compatibility
            if (strcmp(symbols[idx].type, $6) != 0) {
                fprintf(yyout, "ERROR: Incompatible types %s and %s\n", symbols[idx].type, $6);
            } 
        }
    }
    | foreach stmt
    | '{' stmts '}'
    ;

foreach : FOR '(' BASIC ID ':' ID ')' {
            // check if symbol $4 already exists : java doesn't allow this
            if (getSymtabEntryIdx($4) != -1) {
                fprintf(yyout, "Error: Redeclaration of symbol %s\n", $4);
            } else {
                Symbol symbol = {$4, $3, ID, is_curr_symbol_sequence};
                insertInSymtab(symbol);
                fprintf(yyout, "\ntype: %s\nid: %s\nis_sequence: %d\n", $3, $4, is_curr_symbol_sequence);
                displaySymbol(symbol);
                fprintf(yyout, "Number of symbols declared so far: %d\n", num_symbols);
                
                // check if sequence's id is present in the symbol table
                int idx = getSymtabEntryIdx($6);
                if (idx == -1) {
                    fprintf(yyout, "ERROR: Symbol %s is not declared.\n", $6);
                } else {
                    //fprintf(yyout, "Sequence is defined!!\n");
                    // check type compatibility
                    if (strcmp(symbols[idx].type, $3) != 0) {
                        fprintf(yyout, "ERROR: Incompatible types %s and %s\n", symbols[idx].type, $3);
                    } 
                }
            }
        }
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
    '(' expr ')' { $$ = $2; }
    | ID {
        int idx = getSymtabEntryIdx($1);
        if (idx == -1) {
            fprintf(yyout, "ERROR: Symbol %s is not declared!\n", $1);
        } else {
            $$ = symbols[idx].type;
        }
        
    }
    | INTEGER { $$ = "int"; }
    | REAL { $$ = "double"; }
    ;
    
%%

int main() {
    yyout = fopen("output.txt", "w");
    yyparse();
}

