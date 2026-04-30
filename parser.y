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

/* Tokens from Lexer */
%token <str> ID NUMBER FLOAT_LIT
%token INT FLOAT CHAR VOID
%token IF ELSE WHILE FOR DO SWITCH CASE BREAK CONTINUE RETURN
%token PLUS MINUS MULT DIV MOD INC DEC
%token ASSIGN ADD_ASSIGN SUB_ASSIGN
%token EQ NEQ LT GT LTE GTE
%token AND OR NOT
%token BIT_AND BIT_OR BIT_XOR SHL SHR
%token SEMI COMMA LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token STATIC CONST

%type <node> program stmt_list stmt expr decl assign if_stmt while_stmt for_stmt cond

/* Operator Precedence (Lowest to Highest) */
%right ASSIGN ADD_ASSIGN SUB_ASSIGN
%left OR
%left AND
%left BIT_OR
%left BIT_XOR
%left BIT_AND
%left EQ NEQ
%left LT GT LTE GTE
%left SHL SHR
%left PLUS MINUS
%left MULT DIV MOD
%right NOT INC DEC

%%

program:
    stmt_list { root = create_node("Program", "", $1, NULL); }
    ;

stmt_list:
    stmt stmt_list { $$ = create_node("Statements", "", $1, $2); }
    | /* empty */ { $$ = NULL; }
    ;

stmt:
    decl SEMI        { $$ = $1; }
    | assign SEMI    { $$ = $1; }
    | if_stmt        { $$ = $1; }
    | while_stmt     { $$ = $1; }
    | for_stmt       { $$ = $1; }
    | RETURN expr SEMI { $$ = create_node("Return", "", $2, NULL); }
    | LBRACE stmt_list RBRACE { $$ = $2; }
    | BREAK SEMI     { $$ = create_node("Control", "break", NULL, NULL); }
    ;

decl:
    INT ID    { insert_symbol($2, "int"); $$ = create_node("Declaration", "int", create_node("Identifier", $2, NULL, NULL), NULL); }
    | FLOAT ID { insert_symbol($2, "float"); $$ = create_node("Declaration", "float", create_node("Identifier", $2, NULL, NULL), NULL); }
    ;

assign:
    ID ASSIGN expr { 
        if (lookup_symbol($1) == -1) printf("Semantic Error: Undeclared '%s'\n", $1);
        $$ = create_node("Assignment", "=", create_node("Identifier", $1, NULL, NULL), $3); 
    }
    | ID ADD_ASSIGN expr { $$ = create_node("Assignment", "+=", create_node("Identifier", $1, NULL, NULL), $3); }
    ;

if_stmt:
    IF LPAREN cond RPAREN stmt { $$ = create_node("If", "", $3, $5); }
    | IF LPAREN cond RPAREN stmt ELSE stmt { $$ = create_node("IfElse", "", $3, create_node("Else", "", $5, $7)); }
    ;

while_stmt:
    WHILE LPAREN cond RPAREN stmt { $$ = create_node("While", "", $3, $5); }
    | DO stmt WHILE LPAREN cond RPAREN SEMI { $$ = create_node("DoWhile", "", $2, $5); }
    ;

for_stmt:
    FOR LPAREN assign SEMI cond SEMI assign RPAREN stmt {
        ASTNode* header = create_node("ForHeader", "", $3, create_node("ForCondIter", "", $5, $7));
        $$ = create_node("ForLoop", "", header, $9);
    }
    ;

cond:
    expr LT expr  { $$ = create_node("Operator", "<", $1, $3); }
    | expr GT expr  { $$ = create_node("Operator", ">", $1, $3); }
    | expr EQ expr  { $$ = create_node("Operator", "==", $1, $3); }
    | expr NEQ expr { $$ = create_node("Operator", "!=", $1, $3); }
    | expr AND expr { $$ = create_node("Operator", "&&", $1, $3); }
    ;

expr:
    expr PLUS expr  { $$ = create_node("Operator", "+", $1, $3); }
    | expr MINUS expr { $$ = create_node("Operator", "-", $1, $3); }
    | expr MULT expr  { $$ = create_node("Operator", "*", $1, $3); }
    | expr DIV expr   { $$ = create_node("Operator", "/", $1, $3); }
    | ID              { $$ = create_node("Identifier", $1, NULL, NULL); }
    | NUMBER          { $$ = create_node("Number", $1, NULL, NULL); }
    | FLOAT_LIT       { $$ = create_node("FloatLiteral", $1, NULL, NULL); }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse Error: %s at line %d\n", s, yylineno);
}
