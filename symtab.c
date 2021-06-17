#include <stdio.h>
#include "symtab.h"

#define CAPACITY 1024
// number of reserved words should be constant
const int num_reserved_words = 41;

// number of symbols (ids) in the program will change
// initialize to num_reserved_words so that next entry
// is inserted at symbols[num_reserved_words++];
int num_symbols = num_reserved_words;

Symbol symbols[CAPACITY] = {
    {"abstract", NULL, ABSTRACT, 0},
    {"continue", NULL, CONTINUE, 0},
    {"for", NULL, FOR, 0},
    {"new", NULL, NEW, 0},
    {"switch", NULL, SWITCH, 0},
    {"assert", NULL, ASSERT, 0},
    {"default", NULL, DEFAULT, 0},
    {"goto", NULL, GOTO, 0},
    {"package", NULL, PACKAGE, 0},
    {"synchronized", NULL, SYNCHRONIZED, 0},
    {"do", NULL, DO, 0},
    {"if", NULL, IF, 0},
    {"private", NULL, PRIVATE, 0},
    {"this", NULL, THIS, 0},
    {"break", NULL, BREAK, 0},
    {"implements", NULL, IMPLEMENTS, 0},
    {"protected", NULL, PROTECTED, 0},
    {"throw", NULL, THROW, 0},
    {"else", NULL, ELSE, 0},
    {"import", NULL, IMPORT, 0},
    {"public", NULL, PUBLIC, 0},
    {"throws", NULL, THROWS, 0},
    {"case", NULL, CASE, 0},
    {"enum", NULL, ENUM, 0},
    {"instanceof", NULL, INSTANCEOF, 0},
    {"return", NULL, RETURN, 0},
    {"transient", NULL, TRANSIENT, 0},
    {"catch", NULL, CATCH, 0},
    {"extends", NULL, EXTENDS, 0},
    {"try", NULL, TRY, 0},
    {"final", NULL, FINAL, 0},
    {"interface", NULL, INTERFACE, 0},
    {"static", NULL, STATIC, 0},
    {"class", NULL, CLASS, 0},
    {"finally", NULL, FINALLY, 0},
    {"strictfp", NULL, STRICTFP, 0},
    {"volatile", NULL, VOLATILE, 0},
    {"const", NULL, CONST, 0},
    {"native", NULL, NATIVE, 0},
    {"super", NULL, SUPER, 0},
    {"while", NULL, WHILE, 0}
};

void displaySymbol(Symbol symbol) {
    printf("\n-------------------------\n");
    printf("name : %s\n", symbol.name);
    printf("type : %s\n", symbol.type);
    printf("token: %d\n", symbol.token);
    printf("is_sequence: %d\n", symbol.is_sequence);
    printf("-------------------------\n");
}

/*
 * If str is a reserved keyword, then isReserved
 * returns the corresponding token of it.
 *
 * Otherwise, it returns -1, which indicates it's
 * not a reserved keyword.
 */

void insertInSymtab(const Symbol symbol) {
    symbols[num_symbols++] = symbol;
}

int getSymtabEntryIdx(const char *name) {
    for (int i = 0; i < num_symbols; i++) {
        if (strcmp(name, symbols[i].name) == 0) {
            return i;
        }
    }
    // not found
    return -1;
}
