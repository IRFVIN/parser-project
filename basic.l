%{
#include <stdio.h>
#include "y.tab.h"
%}

DIGIT       [0-9]
FRACTION    \.{DIGIT}+
EXPONENT    (E|E(\+|\-)){DIGIT}+
REAL        ({DIGIT}+{FRACTION})|({DIGIT}+{EXPONENT})|({DIGIT}+{FRACTION}{EXPONENT})
INTEGER     {DIGIT}+

BASIC    boolean|byte|char|short|int|long|float|double
KEYWORD  for
ID  [_a-zA-Z][A-Za-z0-9_]*
WS  [ \n\t]+




%%
{REAL} {printf("REAL number: %s\n", yytext);}
{INTEGER} {printf("INTEGER number: %s\n", yytext); return INTEGER; }
{WS}    /* ignore */
{}
{BASIC} {printf("BASIC type: %s\n", yytext); return BASIC;}
{KEYWORD}    {printf("KEYWORD: %s\n", yytext); }
{ID}    {printf("IDENTIFIER: %s\n", yytext); return ID; }
.       {printf("TOKEN: %s\n", yytext); return yytext[0];}
%%

