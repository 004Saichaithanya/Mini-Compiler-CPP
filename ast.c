#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

ASTNode* create_node(const char* type, const char* value, ASTNode* left, ASTNode* right) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    strncpy(node->type, type, sizeof(node->type) - 1);
    node->type[sizeof(node->type) - 1] = '\0';
    
    if (value) {
        strncpy(node->value, value, sizeof(node->value) - 1);
        node->value[sizeof(node->value) - 1] = '\0';
    } else {
        node->value[0] = '\0';
    }
    
    node->left = left;
    node->right = right;
    return node;
}

void print_ast(ASTNode* node, int level) {
    if (node == NULL) return;
    
    for (int i = 0; i < level; i++) {
        printf("  ");
    }
    if (strlen(node->value) > 0) {
        printf("|-- %s (%s)\n", node->type, node->value);
    } else {
        printf("|-- %s\n", node->type);
    }
    
    print_ast(node->left, level + 1);
    print_ast(node->right, level + 1);
}

void free_ast(ASTNode* node) {
    if (node == NULL) return;
    free_ast(node->left);
    free_ast(node->right);
    free(node);
}
