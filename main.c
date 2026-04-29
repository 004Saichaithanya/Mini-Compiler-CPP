#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "semantic.h"
#include "optimizer.h"
#include "icg.h"

extern FILE* yyin;
extern int yyparse();
extern ASTNode* root;

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE* file = fopen(argv[1], "r");
    if (!file) {
        printf("Error: Could not open file %s\n", argv[1]);
        return 1;
    }

    yyin = file;
    init_symbol_table();

    printf("=== PHASE 1 & 2: Lexical & Syntax Analysis ===\n");
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
        return 1;
    }
    
    printf("\n=== Abstract Syntax Tree (AST) ===\n");
    print_ast(root, 0);

    printf("\n=== PHASE 3: Semantic Analysis ===\n");
    print_symbol_table();

    printf("\n=== PHASE 4: Intermediate Code Generation (Before Opt) ===\n");
    generate_icg(root);

    printf("\n=== PHASE 5: Optimization (Constant Folding) ===\n");
    optimize_ast(root);
    printf("AST Optimized successfully.\n");
    
    printf("\n=== Abstract Syntax Tree (After Optimization) ===\n");
    print_ast(root, 0);

    printf("\n=== PHASE 6: Intermediate Code Generation (After Opt) ===\n");
    generate_icg(root);

    free_ast(root);
    fclose(file);
    return 0;
}
