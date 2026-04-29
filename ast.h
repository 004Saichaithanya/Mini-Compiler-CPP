#ifndef AST_H
#define AST_H

typedef struct ASTNode {
    char type[30];
    char value[30];
    struct ASTNode *left;
    struct ASTNode *right;
} ASTNode;

ASTNode* create_node(const char* type, const char* value, ASTNode* left, ASTNode* right);
void print_ast(ASTNode* node, int level);
void free_ast(ASTNode* node);

#endif
