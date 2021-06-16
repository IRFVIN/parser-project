#ifndef SYMTAB_H_
#define SYMTAB_H_

#include "y.tab.h"
#include <string.h>

typedef struct Word {
  char *lexeme;
  int token;
} Word;

#define CAPACITY 1024
const int num_reserved_words = 41;
Word words[CAPACITY] = {
    {"abstract", ABSTRACT},
    {"continue", CONTINUE},
    {"for", FOR},
    {"new", NEW},
    {"switch", SWITCH},
    {"assert", ASSERT},
    {"default", DEFAULT},
    {"goto", GOTO},
    {"package", PACKAGE},
    {"synchronized", SYNCHRONIZED},
    {"do", DO},
    {"if", IF},
    {"private", PRIVATE},
    {"this", THIS},
    {"break", BREAK},
    {"implements", IMPLEMENTS},
    {"protected", PROTECTED},
    {"throw", THROW},
    {"else", ELSE},
    {"import", IMPORT},
    {"public", PUBLIC},
    {"throws", THROWS},
    {"case", CASE},
    {"enum", ENUM},
    {"instanceof", INSTANCEOF},
    {"return", RETURN},
    {"transient", TRANSIENT},
    {"catch", CATCH},
    {"extends", EXTENDS},
    {"try", TRY},
    {"final", FINAL},
    {"interface", INTERFACE},
    {"static", STATIC},
    {"class", CLASS},
    {"finally", FINALLY},
    {"strictfp", STRICTFP},
    {"volatile", VOLATILE},
    {"const", CONST},
    {"native", NATIVE},
    {"super", SUPER},
    {"while", WHILE},
};

/*
 * If str is a reserved keyword, then isReserved
 * returns the corresponding token of it.
 *
 * Otherwise, it returns -1, which indicates it's
 * not a reserved keyword.
 */
int isReserved(const char *str) {
  for (int i = 0; i < num_reserved_words; i++) {
    if (strcmp(words[i].lexeme, str) == 0) {
      return words[i].token;
    }
  }
  // not a reserved keyword
  return -1;
}

#endif
