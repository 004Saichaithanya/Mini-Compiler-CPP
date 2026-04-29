#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "icg.h"

static int temp_counter = 1;
static int label_counter = 1;

int new_temp() {
    return temp_counter++;
}

int new_label() {
    return label_counter++;
}

// Generate TAC and return the name of the variable/temp holding the result
char* generate_tac(ASTNode* node) {
    if (node == NULL) return NULL;

    if (strcmp(node->type, "Number") == 0 || strcmp(node->type, "Identifier") == 0) {
        return node->value; // Just return the value or name
    }

    if (strcmp(node->type, "Operator") == 0) {
        char* left_val = generate_tac(node->left);
        char* right_val = generate_tac(node->right);
        
        int temp_num = new_temp();
        char* result_temp = (char*)malloc(10);
        sprintf(result_temp, "t%d", temp_num);
        
        printf("%s = %s %s %s\n", result_temp, left_val, node->value, right_val);
        return result_temp;
    }

    if (strcmp(node->type, "Assignment") == 0) {
        char* right_val = generate_tac(node->right);
        printf("%s = %s\n", node->left->value, right_val);
        return node->left->value;
    }
    
    if (strcmp(node->type, "If") == 0) {
        char* cond_val = generate_tac(node->left);
        int l_end = new_label();
        
        printf("ifFalse %s goto L%d\n", cond_val, l_end);
        generate_tac(node->right); // the body
        printf("L%d:\n", l_end);
        return NULL;
    }
    
    if (strcmp(node->type, "While") == 0) {
        int l_start = new_label();
        int l_end = new_label();
        
        printf("L%d:\n", l_start);
        char* cond_val = generate_tac(node->left);
        printf("ifFalse %s goto L%d\n", cond_val, l_end);
        
        generate_tac(node->right); // the body
        printf("goto L%d\n", l_start);
        printf("L%d:\n", l_end);
        return NULL;
    }

    if (strcmp(node->type, "Statements") == 0 || strcmp(node->type, "Program") == 0) {
        generate_tac(node->left);
        generate_tac(node->right);
        return NULL;
    }

    // Ignore declaration nodes for ICG
    if (strcmp(node->type, "Declaration") == 0) {
        return NULL;
    }

    return NULL;
}

void generate_icg(ASTNode* node) {
    temp_counter = 1;
    label_counter = 1;
    generate_tac(node);
}
