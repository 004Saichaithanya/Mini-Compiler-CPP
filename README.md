# 🛠️ Mini-Compiler Project

Welcome to the Mini-Compiler project! This is a complete, modular compiler built from scratch to translate a simplified C-like language into Intermediate Code (Three Address Code). It is designed to be simple, educational, and easy to understand.

## 🚀 Technologies Used

* **Lexical Analysis:** **Flex** (Fast Lexical Analyzer)
* **Syntax Analysis:** **YACC** (Yet Another Compiler-Compiler)
* **Core Logic & Data Structures:** **C Language**

---

## ⚙️ How It Works: The 5 Phases of Our Compiler

Our compiler processes source code sequentially through five distinct phases. Here is a simple explanation of what each phase does and how it is implemented in our project.

### 1️⃣ Phase 1: Lexical Analysis
**What it does:** It reads the raw source code character by character and groups them into meaningful chunks called **Tokens**. 
**How we built it (`lexer.l`):** We use **Flex**. We wrote regular expressions to identify keywords (like `int`, `if`, `while`), numbers, identifiers (variable names), and math operators (`+`, `-`, `=`, etc.). Flex ignores blank spaces and comments, handing only the clean tokens to the next phase.

### 2️⃣ Phase 2: Syntax Analysis & AST Generation
**What it does:** It takes the tokens from Phase 1 and checks if they follow the grammatical rules of our language. At the same time, it builds an **Abstract Syntax Tree (AST)**, which is a structural map of the code.
**How we built it (`parser.y` & `ast.c`):** We use **YACC** to define grammar rules (e.g., an assignment is `ID = Expression`). Whenever YACC matches a rule, our C code creates an `ASTNode` and links it together into a large tree. The AST strips away unnecessary characters like semicolons and just keeps the core operations.

### 3️⃣ Phase 3: Semantic Analysis
**What it does:** It checks if the code makes logical sense. For example, you shouldn't be able to use a variable that was never declared, or declare the same variable twice.
**How we built it (`semantic.c`):** We implemented a **Symbol Table** (a simple array structure). When the parser sees `int x;`, we save `x` in the Symbol Table. When the code later tries to do `x = 5;`, we look up `x` in the Symbol Table to ensure it exists.

### 4️⃣ Phase 4: Code Optimization (Constant Folding)
**What it does:** It tries to make the code faster before generating the final output. If it sees math that can be solved right now, it solves it.
**How we built it (`optimizer.c`):** We traverse our AST from the bottom up. If we find an operator node (like `+`) where both the left and right children are plain numbers (e.g., `2 + 3`), we calculate the result (`5`) immediately and replace the whole subtree with just that final number. 

### 5️⃣ Phase 5: Intermediate Code Generation (ICG)
**What it does:** It translates the complex AST into simple, assembly-like instructions called **Three Address Code (TAC)**. TAC breaks down complex equations into single, simple steps using temporary variables.
**How we built it (`icg.c`):** We traverse the AST again. Every time we process an operation, we generate a new temporary variable (like `t1`, `t2`) and print the instruction. We also generate labels (like `L1:`) for `if` conditions and `while` loops to handle jumping around the code.

---

## 📁 Project Structure

* `lexer.l` - Flex rules for generating tokens.
* `parser.y` - YACC grammar rules for building the AST.
* `ast.h` / `ast.c` - Defines the tree structure and handles printing it visually.
* `semantic.h` / `semantic.c` - Manages the Symbol Table and semantic error checking.
* `optimizer.h` / `optimizer.c` - Contains the logic for Constant Folding.
* `icg.h` / `icg.c` - Traverses the AST to generate Three Address Code.
* `main.c` - The main driver that runs all 5 phases in order.
* `sample_input.c` - A test file containing sample code to compile.
* `run.bat` / `commands.txt` - Scripts and instructions to compile and run the project.

---

## 💻 How to Run This Project on Windows

### Prerequisites
Make sure you have the following tools added to your system PATH:
1. **Flex**
2. **YACC** (or Bison configured as Yacc)
3. **GCC** (MinGW C Compiler)

### Running Automatically
Simply double click the **`run.bat`** file. 
It will automatically:
1. Run Flex to generate `lex.yy.c`
2. Run YACC to generate `y.tab.c` and `y.tab.h`
3. Compile all C files using GCC
4. Execute the compiler with `sample_input.c`

### Running Manually
If you want to run it step-by-step in your terminal, use these commands:
```cmd
flex lexer.l
yacc -d parser.y
gcc lex.yy.c y.tab.c ast.c semantic.c optimizer.c icg.c main.c -o compiler.exe
compiler.exe sample_input.c
```
