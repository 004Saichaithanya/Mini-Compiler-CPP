@echo off
echo ========================================
echo        Mini-Compiler Build ^& Run
echo ========================================

echo.
echo [1/3] Running Flex...
flex lexer.l
if %errorlevel% neq 0 (
    echo Flex failed! Please make sure flex is installed and added to your PATH.
    pause
    exit /b %errorlevel%
)

echo.
echo [2/3] Running Bison...
bison -d parser.y
if %errorlevel% neq 0 (
    echo Bison failed! Please make sure bison is installed and added to your PATH.
    pause
    exit /b %errorlevel%
)

echo.
echo [3/3] Compiling C files...
gcc lex.yy.c parser.tab.c ast.c semantic.c optimizer.c icg.c main.c -o compiler.exe
if %errorlevel% neq 0 (
    echo GCC compilation failed! Please make sure MinGW/gcc is installed.
    pause
    exit /b %errorlevel%
)

echo.
echo Build Successful!
echo ========================================
echo        Executing Sample Input
echo ========================================
echo.

compiler.exe sample_input.c

echo.
echo ========================================
pause
