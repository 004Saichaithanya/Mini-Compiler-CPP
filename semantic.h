#ifndef SEMANTIC_H
#define SEMANTIC_H

#define MAX_SYMBOLS 100

typedef struct Symbol {
    char name[30];
    char type[30];
} Symbol;

extern Symbol symbol_table[MAX_SYMBOLS];
extern int symbol_count;

void init_symbol_table();
int insert_symbol(const char* name, const char* type);
int lookup_symbol(const char* name);
void print_symbol_table();

#endif
