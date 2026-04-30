/* semantic.c */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "semantic.h"

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;
int current_scope = 0;

/* initialize */
void init_symbol_table() {
    symbol_count = 0;
    current_scope = 0;
}

/* enter new block scope */
void enter_scope() {
    current_scope++;
}

/* exit block scope */
void exit_scope() {
    while (symbol_count > 0 &&
           symbol_table[symbol_count - 1].scope == current_scope) {
        symbol_count--;
    }
    current_scope--;
}

/* search variable from latest scope */
int lookup_symbol(const char *name) {
    for (int i = symbol_count - 1; i >= 0; i--) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

/* search only current scope */
int lookup_current_scope(const char *name) {
    for (int i = symbol_count - 1; i >= 0; i--) {
        if (symbol_table[i].scope == current_scope &&
            strcmp(symbol_table[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

/* return size based on datatype */
int get_size(char *type) {
    if (strcmp(type, "int") == 0) return 4;
    if (strcmp(type, "float") == 0) return 4;
    if (strcmp(type, "char") == 0) return 1;
    if (strcmp(type, "double") == 0) return 8;
    return 0;
}

/* insert variable */
int insert_symbol(const char *name, const char *type) {

    if (lookup_current_scope(name) != -1) {
        printf("Semantic Error: '%s' already declared in same scope.\n", name);
        return 0;
    }

    if (symbol_count >= MAX_SYMBOLS) {
        printf("Semantic Error: Symbol table full.\n");
        return 0;
    }

    strcpy(symbol_table[symbol_count].name, name);
    strcpy(symbol_table[symbol_count].type, type);
    strcpy(symbol_table[symbol_count].value, "NULL");

    symbol_table[symbol_count].scope = current_scope;
    symbol_table[symbol_count].size = get_size((char *)type);

    symbol_count++;
    return 1;
}

/* check declared */
int check_declared(const char *name) {
    if (lookup_symbol(name) == -1) {
        printf("Semantic Error: '%s' not declared.\n", name);
        return 0;
    }
    return 1;
}

/* type check */
int check_type_compatible(const char *type, const char *value) {

    if (strcmp(type, "int") == 0) {
        for (int i = 0; value[i]; i++) {
            if (!isdigit(value[i]) && value[i] != '-') return 0;
        }
        return 1;
    }

    if (strcmp(type, "float") == 0) {
        int dot = 0;
        for (int i = 0; value[i]; i++) {
            if (value[i] == '.') dot++;
            else if (!isdigit(value[i]) && value[i] != '-') return 0;
        }
        return dot <= 1;
    }

    if (strcmp(type, "char") == 0) {
        return strlen(value) == 1;
    }

    return 1;
}

/* assign value */
int assign_value(const char *name, const char *value) {

    int index = lookup_symbol(name);

    if (index == -1) {
        printf("Semantic Error: '%s' not declared.\n", name);
        return 0;
    }

    if (!check_type_compatible(symbol_table[index].type, value)) {
        printf("Semantic Error: Type mismatch for '%s'.\n", name);
        return 0;
    }

    strcpy(symbol_table[index].value, value);
    return 1;
}

/* print table */
void print_symbol_table() {

    printf("\n---------------- Symbol Table ----------------\n");
    printf("%-10s %-10s %-10s %-10s %-10s\n",
           "Name", "Type", "Value", "Scope", "Size");
    printf("------------------------------------------------\n");

    for (int i = 0; i < symbol_count; i++) {
        printf("%-10s %-10s %-10s %-10d %-10d\n",
               symbol_table[i].name,
               symbol_table[i].type,
               symbol_table[i].value,
               symbol_table[i].scope,
               symbol_table[i].size);
    }

    printf("------------------------------------------------\n");
}