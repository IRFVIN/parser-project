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


/*
 * The role of the Syntax Analyzer is to try to derive the sequence
 * of tokens returned by the lexical Analyzer using the listed rules
 * of the grammar. If the sequence of tokens can't be derived, it prints
 * an error. Otherwise, it prints "Syntactically valid program". It also
 * checks for redeclaration errors.
 * 
 * Although not a part of syntax analysis, we have tried to implement basic
 * type checking which is executed whenever the corresponding production is
 * used to reduce the sentence.
 *
 * The core part of the project is to parse the Java foreach loop. For that,
 * we need to define a basic grammar for a valid program.
 *
 * program -> block             A program is a block of code.
 * block -> { decls stmts }     A block is enclosed in curly braces, which consists of declarations and statements.
 * 
 * More details about the decls nonterminal can be obtained by referring to the yacc grammar listed below.
 * stmts -> stmts stmt | empty
 * stmt -> ID assignment | ID [ INTEGER ] = expr ';'        A statement can be an assignment statement (basic type or sequence type) 
 * stmt -> foreach stmt | { stmts }       A statement can be a foreach statement followed by a single statement or a set of statements enclosed in { }.
 * 
 * Now comes the core part of the project, the foreach loop.
 * foreach -> FOR '(' BASIC ID ':' ID ')'
 * A foreach loop consists of the reserved keyword 'for', opening parentheses, a basic type, an ID, a colon, another ID, followed by a closing parentheses
 * and then one or more statements.
 * A syntactically valid foreach loop should be able to get derived from this. If it does, then this production will be used to reduce the sequence of
 * tokens received from the lexical analyzer. When it is used for production, the corresponding code written in the yacc file will get executed.
 * This code:
 * 1. checks if the first ID is a redeclaration, since Java disallows this.
 * 2. checks if the second ID is indeed a sequence type, i.e. is iterable.
 * 3. type checking: checks whether the type of the first ID is compatible with the underlying type of the sequence ID.
 */

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
    block   {printf("Syntactically valid program!\n"); writeSymtab(yyout);}
    | error { yyerror("Invalid Syntax!\n");}
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
        Symbol curr_symbol = {strdup($2), strdup($1), ID, is_curr_symbol_sequence};
        
        if (getSymtabEntryIdx(curr_symbol.name) != -1) {
            fprintf(yyout, "ERROR (declaration) : Redeclaration of symbol %s\n", $2);
        } else {
            insertInSymtab(curr_symbol);
            // and check type compatibility
            if ($3 != NULL && strcmp($1, $3) != 0) {
                fprintf(yyout, "ERROR (declaration) : Incompatible types %s (%s) and (%s) \n", curr_symbol.name, curr_symbol.type, $3);
            }
        }
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
            fprintf(yyout, "\nERROR (assignment): Symbol %s is not declared.\n", $1);
        } else {
            // check type compatibility
            if ($2 != NULL && strcmp(symbols[idx].type, $2) != 0) {
                fprintf(yyout, "\nERROR (assignment): Incompatible types %s (%s) and %s\n", symbols[idx].name ,symbols[idx].type, $2);
            } 
        }
    }
    | ID '[' INTEGER ']' '=' expr ';' {
        // check if ID is present in the symbol table
        int idx = getSymtabEntryIdx($1);
        //printf("HERE check %s\n", $1);
        if (idx == -1) {
            fprintf(yyout, "\nERROR (array assignment): Symbol %s is not declared.\n", $1);
        } else {
            // check that ID is a sequence
            if (symbols[idx].is_sequence != 1) {
                fprintf(yyout, "\nERROR (array assignment): Symbol %s is not a sequence.\n", symbols[idx].name);
            } else if (strcmp(symbols[idx].type, $6) != 0) {
                // then check for type compatibility
                fprintf(yyout, "\nERROR (array assignment): Incompatible types %s (%s) and expr (%s) \n", symbols[idx].name, symbols[idx].type, $6);
            } 
        }
    }
    | foreach stmt
    | '{' stmts '}'
    ;

foreach : FOR '(' BASIC ID ':' ID ')' {
            // check if symbol $4 already exists : java doesn't allow this
            fprintf(yyout, "\n\nforeach symbols: %s, %s, %s\n", $3, $4, $6);
            if (getSymtabEntryIdx($4) != -1) {
                fprintf(yyout, "ERROR (foreach): Redeclaration of symbol %s\n", $4);
            } else {
                // symbol $4 is not a sequence, so is_sequence = 0
                Symbol symbol = {strdup($4), strdup($3), ID, 0};
                insertInSymtab(symbol);
                
                // check if sequence's id ($6) is present in the symbol table
                int idx = getSymtabEntryIdx($6);
                if (idx == -1) {
                    fprintf(yyout, "ERROR (foreach): Symbol %s is not declared.\n", $6);
                } else {
                    // check that ID is a sequence
                    if (symbols[idx].is_sequence != 1) {
                        fprintf(yyout, "ERROR (foreach): Symbol %s is not a sequence.\n", $6);
                    } else if (strcmp(symbols[idx].type, $3) != 0) {
                        // check type compatibility
                        fprintf(yyout, "ERROR (foreach): Incompatible types: %s (%s) and  %s (%s)\n", symbols[idx].name, symbols[idx].type, $4, $3);
                    } else {
                        fprintf(yyout, "Syntactically valid and type compatible foreach loop\n");
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
            fprintf(yyout, "ERROR (factor -> ID): Symbol %s is not declared!\n", $1);
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

