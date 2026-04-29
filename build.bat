@echo off
echo Building Mini-Compiler...

echo 1. Running Flex...
flex lexer.l

echo 2. Running Bison...
bison -d parser.y

echo 3. Compiling with GCC...
gcc lex.yy.c parser.tab.c ast.c semantic.c optimizer.c icg.c main.c -o compiler.exe

if %errorlevel% neq 0 (
    echo Build failed.
) else (
    echo Build successful! Run with: compiler.exe sample_input.c
)
