#ifndef SYMTAB_H_
#define SYMTAB_H_

#include "y.tab.h"
#include <string.h>

typedef struct Symbol {
    char *name;
    char *type;
    int token;
    int is_sequence;
} Symbol;

extern const int num_reserved_words;
extern int num_symbols;
extern Symbol symbols[];

void displaySymbol(Symbol symbol);
void insertInSymtab(const Symbol symbol);
int getSymtabEntryIdx(const char *name);

#endif
