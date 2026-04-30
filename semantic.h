/* semantic.h */
#ifndef SEMANTIC_H
#define SEMANTIC_H

#define MAX_SYMBOLS 100

typedef struct Symbol {
    char name[30];      // variable name
    char type[20];      // int, float, char
    char value[50];     // assigned value
    int scope;          // scope level
    int size;           // memory size in bytes
} Symbol;

extern Symbol symbol_table[MAX_SYMBOLS];
extern int symbol_count;
extern int current_scope;

/* functions */
void init_symbol_table();
void enter_scope();
void exit_scope();

int lookup_symbol(const char *name);
int lookup_current_scope(const char *name);

int insert_symbol(const char *name, const char *type);
int assign_value(const char *name, const char *value);

int check_declared(const char *name);
int check_type_compatible(const char *type, const char *value);

void print_symbol_table();

#endif