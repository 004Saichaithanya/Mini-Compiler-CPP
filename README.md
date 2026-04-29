# Mini-Compiler

A modular mini-compiler built using Flex, Bison, and C. It translates a subset of C-like syntax into Three Address Code (TAC) and applies basic AST-level optimizations (constant folding).

## Features

1. **Lexical Analysis:** Flex tokenizes the input.
2. **Syntax Analysis & AST Generation:** YACC parses tokens and constructs a visual Abstract Syntax Tree.
3. **Semantic Analysis:** Validates variable declarations and scope using a Symbol Table.
4. **Intermediate Code Generation (ICG):** Generates TAC from the AST.
5. **Optimization:** Applies recursive Constant Folding to optimize arithmetic operations.

## Project Structure

- `lexer.l`: Flex definitions
- `parser.y`: YACC grammar
- `ast.c` / `ast.h`: AST node definition and tree generation
- `semantic.c` / `semantic.h`: Symbol table and error checking
- `optimizer.c` / `optimizer.h`: Constant folding routines
- `icg.c` / `icg.h`: TAC generator
- `main.c`: Driver code tying phases together
- `sample_input.c`: Test file
- `build.bat`: Windows compilation script

## Prerequisites
- `flex` (or `win_flex`)
- `yacc` (or `bison` configured to run as yacc)
- `gcc` (MinGW or equivalent)

## Building the Project

On Windows, run the provided script:
```bat
build.bat
```

## Running the Compiler

Run the generated executable passing the sample input file:
```bat
compiler.exe sample_input.c
```
