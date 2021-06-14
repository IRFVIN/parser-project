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

%%
{WS}        /* ignore whitespaces */
{REAL}      {printf("REAL number: %s\n", yytext); return REAL; }
{INTEGER}   {printf("INTEGER number: %s\n", yytext); return INTEGER; }
{BASIC}     {printf("BASIC type: %s\n", yytext); return BASIC;}
{ID}        {
                int is_reserved = isReserved(yytext);
                if ( is_reserved != -1 ) {
                    printf("Reserved keyword: %s\n", yytext);
                    return is_reserved;
                } else {
                    // since it's not a reserved keyword, it's an identifier
                    printf("IDENTIFIER: %s\n", yytext); return ID;
                }
            }
.           {printf("other token: %s\n", yytext); return yytext[0];}
%%

