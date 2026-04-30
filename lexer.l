%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "y.tab.h"
extern int yylineno;
%}

%option noyywrap
%option yylineno

%%

/* Keywords */
"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"void"      { return VOID; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }
"do"        { return DO; }
"switch"    { return SWITCH; }
"case"      { return CASE; }
"break"     { return BREAK; }
"continue"  { return CONTINUE; }
"return"    { return RETURN; }
"static"    { return STATIC; }
"const"     { return CONST; }

/* Arithmetic Operators */
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }
"%"         { return MOD; }
"++"        { return INC; }
"--"        { return DEC; }

/* Relational Operators */
"=="        { return EQ; }
"!="        { return NEQ; }
"<"         { return LT; }
">"         { return GT; }
"<="        { return LTE; }
">="        { return GTE; }

/* Logical Operators */
"&&"        { return AND; }
"||"        { return OR; }
"!"         { return NOT; }

/* Assignment Operators */
"="         { return ASSIGN; }
"+="        { return ADD_ASSIGN; }
"-="        { return SUB_ASSIGN; }

/* Bitwise Operators */
"&"         { return BIT_AND; }
"|"         { return BIT_OR; }
"^"         { return BIT_XOR; }
"<<"        { return SHL; }
">>"        { return SHR; }

/* Punctuation & Delimiters */
";"         { return SEMI; }
","         { return COMMA; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }

/* Identifiers and Literals */
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
[0-9]+\.[0-9]+         { yylval.str = strdup(yytext); return FLOAT_LIT; }
[0-9]+                 { yylval.str = strdup(yytext); return NUMBER; }

/* Whitespace and Comments */
[ \t\r\n]+             { /* ignore whitespace */ }
"//".* { /* ignore single-line comments */ }

/* Error Handling */
.           { printf("Lexical Error: Unknown character '%s' at line %d\n", yytext, yylineno); }

%%
