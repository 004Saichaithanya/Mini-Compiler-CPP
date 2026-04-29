%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "semantic.h"

extern int yylex();
extern int yylineno;
void yyerror(const char *s);

ASTNode* root = NULL;
%}

%union {
    char* str;
    struct ASTNode* node;
}

%token <str> ID NUMBER
%token INT IF ELSE WHILE RETURN
%token PLUS MINUS MULT DIV ASSIGN LT GT EQ
%token SEMI COMMA LPAREN RPAREN LBRACE RBRACE

%type <node> program stmt_list stmt expr decl assign if_stmt while_stmt cond

%left LT GT EQ
%left PLUS MINUS
%left MULT DIV

%%
program:
    stmt_list { root = create_node("Program", "", $1, NULL); }
    ;

stmt_list:
    stmt stmt_list { $$ = create_node("Statements", "", $1, $2); }
    | /* empty */ { $$ = NULL; }
    ;

stmt:
    decl SEMI { $$ = $1; }
    | assign SEMI { $$ = $1; }
    | if_stmt { $$ = $1; }
    | while_stmt { $$ = $1; }
    | LBRACE stmt_list RBRACE { $$ = $2; }
    ;

decl:
    INT ID { 
        insert_symbol($2, "int");
        ASTNode* id_node = create_node("Identifier", $2, NULL, NULL);
        $$ = create_node("Declaration", "int", id_node, NULL); 
    }
    ;

assign:
    ID ASSIGN expr { 
        if (lookup_symbol($1) == -1) {
            printf("Semantic Error: Undeclared variable '%s' at line %d\n", $1, yylineno);
        }
        ASTNode* id_node = create_node("Identifier", $1, NULL, NULL);
        $$ = create_node("Assignment", "=", id_node, $3); 
    }
    ;

if_stmt:
    IF LPAREN cond RPAREN stmt { $$ = create_node("If", "", $3, $5); }
    | IF LPAREN cond RPAREN stmt ELSE stmt { $$ = create_node("IfElse", "", $3, create_node("Else", "", $5, $7)); }
    ;

while_stmt:
    WHILE LPAREN cond RPAREN stmt { $$ = create_node("While", "", $3, $5); }
    ;

cond:
    expr LT expr { $$ = create_node("Operator", "<", $1, $3); }
    | expr GT expr { $$ = create_node("Operator", ">", $1, $3); }
    | expr EQ expr { $$ = create_node("Operator", "==", $1, $3); }
    ;

expr:
    expr PLUS expr { $$ = create_node("Operator", "+", $1, $3); }
    | expr MINUS expr { $$ = create_node("Operator", "-", $1, $3); }
    | expr MULT expr { $$ = create_node("Operator", "*", $1, $3); }
    | expr DIV expr { $$ = create_node("Operator", "/", $1, $3); }
    | ID { 
        if (lookup_symbol($1) == -1) {
            printf("Semantic Error: Undeclared variable '%s' at line %d\n", $1, yylineno);
        }
        $$ = create_node("Identifier", $1, NULL, NULL); 
    }
    | NUMBER { $$ = create_node("Number", $1, NULL, NULL); }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse Error: %s at line %d\n", s, yylineno);
}
