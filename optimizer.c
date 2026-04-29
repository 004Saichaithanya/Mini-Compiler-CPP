#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "optimizer.h"

void optimize_ast(ASTNode* node) {
    if (node == NULL) return;

    // Post-order traversal: optimize children first
    optimize_ast(node->left);
    optimize_ast(node->right);

    // If node is an arithmetic operator
    if (strcmp(node->type, "Operator") == 0) {
        if (node->left && node->right &&
            strcmp(node->left->type, "Number") == 0 &&
            strcmp(node->right->type, "Number") == 0) {
            
            int left_val = atoi(node->left->value);
            int right_val = atoi(node->right->value);
            int result = 0;

            if (strcmp(node->value, "+") == 0) result = left_val + right_val;
            else if (strcmp(node->value, "-") == 0) result = left_val - right_val;
            else if (strcmp(node->value, "*") == 0) result = left_val * right_val;
            else if (strcmp(node->value, "/") == 0) {
                if (right_val != 0) result = left_val / right_val;
                else {
                    printf("Warning: Division by zero detected during optimization.\n");
                    return; // Don't optimize division by zero
                }
            } else {
                return; // Unknown operator
            }

            // Replace current node with folded number
            strcpy(node->type, "Number");
            sprintf(node->value, "%d", result);
            
            // Free the left and right children
            free_ast(node->left);
            free_ast(node->right);
            node->left = NULL;
            node->right = NULL;
        }
    }
}
