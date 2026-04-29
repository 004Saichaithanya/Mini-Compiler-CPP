#include <stdio.h>
#include <string.h>
#include "semantic.h"

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

void init_symbol_table() {
    symbol_count = 0;
}

int lookup_symbol(const char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return i; // Found
        }
    }
    return -1; // Not found
}

int insert_symbol(const char* name, const char* type) {
    if (lookup_symbol(name) != -1) {
        printf("Semantic Error: Variable '%s' is already declared.\n", name);
        return 0; // Failure
    }
    if (symbol_count >= MAX_SYMBOLS) {
        printf("Semantic Error: Symbol table is full.\n");
        return 0;
    }
    strcpy(symbol_table[symbol_count].name, name);
    strcpy(symbol_table[symbol_count].type, type);
    symbol_count++;
    return 1; // Success
}

void print_symbol_table() {
    printf("\n--- Symbol Table ---\n");
    printf("%-20s %-20s\n", "Name", "Type");
    printf("----------------------------------------\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%-20s %-20s\n", symbol_table[i].name, symbol_table[i].type);
    }
    printf("----------------------------------------\n");
}
