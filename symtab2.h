#ifndef SYMTAB2_H_
#define SYMTAB2_H_

#include "y.tab.h"
#include <string.h>

typedef struct Symbol {
    char *name;
    char *type;
} Symbol;

#define SYMBTAB_SIZE 100
int num_symbols = 0;
Symbol symbols[SYMBTAB_SIZE];

int getSymtabEntryIdx(char *name) {
    for (int i = 0; i < num_symbols; i++) {
        if (strcmp(name, symbols[i].name) == 0) {
            return i;
        }
    }
    // not found
    return -1;
}

void displaySymbol(Symbol symbol) {
    printf("%s\n", symbol.name);
    printf("%s\n", symbol.type);
}

void insertInSymtab(Symbol symbol) {
    symbols[num_symbols++] = symbol;
}

#endif
