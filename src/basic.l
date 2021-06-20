%{
#include <stdio.h>
#include "y.tab.h"
#include "symtab.h"

/*
 * Role of Lexical Analyzer:
 * 1. ignore white spaces, single line comments, multi line comments
 * 2. handle numbers (integers and floating point)
      and return INTEGER or REAL to the parser.
 * 3. handle reserved words, and, identifiers
 * 4. return any other lexemes as is to the parser
 *
 * To handle reserved words, we create a symtab initialized with
 * these reserved keywords (refer include/symtab.h and src/symtab.c).
 * There are 41 reserved keywords. Therefore, identifiers in the program
 * will be stored from index 41 in the symbol table.
 * During the lexical analysis phase, if any reserved keyword is matched,
 * then we return the corresponding token that is stored in the symbol table.
 * Otherwise, we return the token ID, which stands for identifier.
 */
%}

DIGIT       [0-9]
FRACTION    \.{DIGIT}+
EXPONENT    (E|E(\+|\-)){DIGIT}+
REAL        ({DIGIT}+{FRACTION})|({DIGIT}+{EXPONENT})|({DIGIT}+{FRACTION}{EXPONENT})
INTEGER     {DIGIT}+

BASIC   boolean|byte|char|short|int|long|float|double
ID      [_a-zA-Z][A-Za-z0-9_]*
WS      [ \n\t]+

SL_COMMENT      \/\/.*$
OM_STARS        (\*)+
ML_COMMENT      "/*"([^*]|{OM_STARS}[^*/])*{OM_STARS}"/"

SEQUENCE_TYPE ArrayList

%%
{WS}            /* ignore whitespaces */
{SL_COMMENT}    /* ignore single and multiple line comments */
{ML_COMMENT}

{REAL}      {
        //printf("REAL number: %s\n", yytext); 
        return REAL;
    }
{INTEGER}   {
        //printf("INTEGER number: %s\n", yytext); 
        return INTEGER;
    }
{BASIC}     {
        //printf("BASIC type: %s\n", yytext);
        yylval.stringValue = strdup(yytext);
        //printf(yylval.stringValue);
        return BASIC;
    }
{SEQUENCE_TYPE} {
        //printf("SEQUENCE_TYPE type: %s\n", yytext);
        yylval.stringValue = strdup(yytext); 
        return SEQUENCE_TYPE;
    }
{ID}        {
        int idx = getSymtabEntryIdx(yytext);
        if ( idx != -1 ) {
            // printf("Reserved keyword or already declared ID: %s\n", yytext);
            yylval.stringValue = strdup(yytext);
            return symbols[idx].token;
        } else {
            // first occurence of identifier
            yylval.stringValue = strdup(yytext);
            //  printf("IDENTIFIER: %s %s\n", yytext, yylval.stringValue);
            return ID;
        }
    }
.           {
        // printf("other token: %s\n", yytext);
        return yytext[0];
    }
%%

