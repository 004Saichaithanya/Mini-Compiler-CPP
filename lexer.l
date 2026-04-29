%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "parser.tab.h"

extern int yylineno;
%}

%option noyywrap
%option yylineno

%%
"int"       { return INT; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"return"    { return RETURN; }

[a-zA-Z_][a-zA-Z0-9_]* { 
    yylval.str = strdup(yytext); 
    return ID; 
}

[0-9]+      { 
    yylval.str = strdup(yytext); 
    return NUMBER; 
}

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }
"="         { return ASSIGN; }
"<"         { return LT; }
">"         { return GT; }
"=="        { return EQ; }

";"         { return SEMI; }
","         { return COMMA; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }

[ \t\r\n]+  { /* ignore whitespace */ }
.           { printf("Lexical Error: Unknown character '%s' at line %d\n", yytext, yylineno); }

%%
