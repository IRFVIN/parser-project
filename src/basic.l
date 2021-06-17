%{
#include <stdio.h>
#include "y.tab.h"
#include "symtab.h"
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
            return symbols[idx].token;
        } else {
            // first occurence of identifier
            yylval.stringValue = strdup(yytext);
            //printf("IDENTIFIER: %s\n", yytext);
            return ID;
        }
    }
.           {
        //printf("other token: %s\n", yytext);
        return yytext[0];
    }
%%

