# Compiler Design Viva Questions

This document contains 25+ essential questions and answers to prepare for your Compiler Construction project viva. 

## 🔰 Basic Questions

**1. What is a Compiler?**
A compiler is a program that translates source code written in a high-level programming language into machine code or intermediate code.

**2. What is the difference between a Compiler and an Interpreter?**
A compiler translates the entire program into machine code before execution, resulting in a standalone executable. An interpreter translates and executes the code line-by-line in real-time.

**3. What are the main phases of a compiler?**
Lexical Analysis, Syntax Analysis, Semantic Analysis, Intermediate Code Generation, Code Optimization, and Target Code Generation.

**4. What is Lexical Analysis?**
The first phase of a compiler that reads the source code as a stream of characters and converts it into meaningful sequences called Tokens.

**5. What tool is used for Lexical Analysis in this project?**
Flex (Fast Lexical Analyzer Generator) is used to specify regular expressions and generate the lexer in C.

**6. What is a Token?**
A token is a sequence of characters that represents a fundamental unit of the language, such as keywords (`int`, `if`), identifiers (`x`, `y`), or operators (`+`, `-`).

**7. What is Syntax Analysis (Parsing)?**
The second phase, which takes tokens as input and checks if they form a valid structure according to the formal grammar of the language.

**8. What tool is used for Syntax Analysis?**
Bison (GNU parser generator) is used. It implements a LALR(1) parser.

**9. What is a Grammar?**
A set of rules that defines the syntactic structure of a programming language.

## ⚙️ Intermediate Questions

**10. What is an Abstract Syntax Tree (AST)?**
An AST is a tree representation of the abstract syntactic structure of source code. Each node denotes a construct occurring in the source code.

**11. What is the difference between a Parse Tree and an AST?**
A parse tree contains all the syntactic details (like parentheses and delimiters) representing how the grammar rules were applied. An AST strips away these unnecessary details and keeps only the essential operational structure.

**12. What is Semantic Analysis?**
The phase that checks the program for semantic consistency, such as type checking, ensuring variables are declared before use, and checking for duplicate declarations.

**13. What is a Symbol Table?**
A data structure used by the compiler to store information about variables, functions, and other identifiers, including their names, data types, and scope.

**14. When is the Symbol Table populated?**
It is primarily populated during Lexical Analysis and Syntax Analysis (when declarations are parsed), and extensively used during Semantic Analysis.

**15. What is Intermediate Code Generation (ICG)?**
The process of translating the AST into a machine-independent intermediate representation, which bridges the gap between high-level language and machine code.

**16. What is Three Address Code (TAC)?**
A type of intermediate code where each instruction has at most three operands (e.g., `t1 = a + b`). It uses temporary variables to hold intermediate results.

**17. Why do we need Intermediate Code?**
It separates the front-end (language specific) from the back-end (machine specific). This allows the compiler to be easily adapted to new languages or new hardware architectures.

**18. What is Code Optimization?**
The phase where the intermediate code is transformed to consume fewer resources (like memory or CPU time) without changing the program's output.

## 🚀 Advanced Questions

**19. How does an AST improve error reporting?**
Because the AST nodes map closely to the actual source code operations, the compiler can track the source line numbers (using `yylineno`) and attach them to nodes, providing precise error locations for semantic issues.

**20. Why use a modular compiler design?**
A modular design separates concerns. It allows different developers to work on the lexer, parser, and optimizer independently. It also makes debugging much easier since you can dump the output after each phase.

**21. What is Constant Folding?**
An optimization technique where constant expressions are evaluated at compile-time rather than at runtime. For example, `2 + 3` is replaced with `5`.

**22. How is Constant Folding implemented in this project?**
By performing a post-order traversal of the AST. If a parent operator node finds that both its left and right children are constants, it computes the result, replaces its own value with the result, and deletes the children nodes.

**23. What are the benefits of Constant Folding?**
It reduces the number of instructions generated in the target code, saving CPU cycles during runtime execution.

**24. What happens if a variable is used without being declared?**
The Semantic Analyzer queries the Symbol Table using `lookup_symbol()`. If the symbol is not found, it throws a semantic error and halts code generation.

**25. How do temporary variables (`t1, t2`) work in TAC?**
During ICG, when a complex expression is evaluated, the result of each sub-expression must be stored. A counter generates a new unique temporary variable name for each intermediate step.

**26. Can you describe LALR parsing?**
Look-Ahead LR parsing. It is a bottom-up parsing method that is highly efficient and capable of parsing a large class of context-free grammars, which is why Bison uses it. It resolves shift/reduce conflicts by looking ahead at the next token.

**27. Why write the compiler phases in C rather than C++?**
Using C demonstrates a fundamental understanding of memory management (using `malloc` and `free` for AST nodes) and pointer arithmetic, which are core systems programming concepts. Flex and Bison natively interface exceptionally well with C.
