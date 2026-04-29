@echo off
echo Building Mini-Compiler...

echo 1. Running Flex...
flex lexer.l

echo 2. Running YACC...
yacc -d parser.y

echo 3. Compiling with GCC...
gcc lex.yy.c y.tab.c ast.c semantic.c optimizer.c icg.c main.c -o compiler.exe

if %errorlevel% neq 0 (
    echo Build failed.
) else (
    echo Build successful! Run with: compiler.exe sample_input.c
)
