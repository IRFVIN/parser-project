#include <stdio.h>
#include <string.h>

#include "symtab.h"

int main() {
    char *str = "abstract";
    
    if (isReserved(str) != -1) {
        printf("%d\n", isReserved(str));
        printf("%s is a reserved keyword\n", str);
    } else {
        printf("%s is NOT a reserved keyword\n");
    }
    
    return 0;
}
