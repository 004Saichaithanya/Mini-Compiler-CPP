# 🛠️ Mini-Compiler Project

Welcome to the **Mini-Compiler** project! This is a complete, modular compiler built from scratch to translate a simplified C-like language into **Intermediate Code (Three Address Code)**. It is designed to be educational, efficient, and easy to understand for beginners.

---

## 💻 Technologies Used

* **Lexical Analysis:** [Flex (Fast Lexical Analyzer)](https://github.com/westes/flex)
* **Syntax Analysis:** [YACC (Yet Another Compiler-Compiler) / Bison](https://www.gnu.org/software/bison/)
* **Language:** C / C++
* **Environment:** GCC Compiler & Make/Batch scripts

---

## ⚙️ The 5 Phases of the Compiler

Our compiler processes source code sequentially through five distinct phases. Here is a detailed look at the flow of each stage:

### 1️⃣ Phase 1: Lexical Analysis (The Lexer)
To scan the source code and identify the "vocabulary" of the language.
* **Input:** Raw text from a `.c` file.
* **Process:** Using **Flex** (`lexer.l`), it uses Regular Expressions to group characters into **Tokens** (Keywords, Identifiers, Numbers, Operators). It ignores whitespace and comments.
* **Output:** A stream of Tokens and a **Symbol Table** (storing variable names and their properties).

### 2️⃣ Phase 2: Syntax Analysis (The Parser)
To ensure the tokens are arranged in a grammatically correct order.
* **Input:** The stream of Tokens provided by the Lexer.
* **Process:** Using **YACC** (`parser.y`) and Context-Free Grammar (CFG), it validates the structure (e.g., ensuring an assignment follows the `ID = Expression` rule).
* **Output:** An **Abstract Syntax Tree (AST)**, which is a structural map of the program logic.

### 3️⃣ Phase 3: Semantic Analysis
To check the "meaning" and logic of the code.
* **Input:** The AST from the Parser and the Symbol Table from the Lexer.
* **Process:** Implemented in `semantic.c`, it performs **Type Checking** (ensuring you don't add a string to an int) and **Scope Checking** (ensuring variables are declared before use).
* **Output:** An **Annotated AST** (a verified tree ready for code generation).

### 4️⃣ Phase 4: Intermediate Code Generation (ICG)
To translate the complex tree into simple, linear instructions.
* **Input:** The Annotated AST.
* **Process:** Implemented in `icg.c`, it flattens the tree into **Three Address Code (3AC)**. It uses temporary variables (like `t1`, `t2`) to break down complex expressions into steps with at most three addresses.
* **Output:** **Intermediate Code (3AC)**.

### 5️⃣ Phase 5: Code Optimization
To make the code run faster and take up less memory.
* **Input:** The 3AC instructions.
* **Process:** Implemented in `optimizer.c`, it performs logic cleanup such as **Constant Folding** (calculating `2 + 2` at compile time) and removing unreachable code.
* **Output:** **Optimized Final Code**.

---

## 🔍 Step-by-Step Trace Example

**Input Code:** `c = a + 5;`

| Phase | Output Result |
| :--- | :--- |
| **Lexical** | `ID(c)`, `ASSIGN(=)`, `ID(a)`, `PLUS(+)`, `NUM(5)` |
| **Syntax** | AST Node: `(Assignment: c, (Add: a, 5))` |
| **Semantic** | Verified: `a` and `c` exist as compatible types. |
| **ICG** | `t1 = a + 5` <br> `c = t1` |
| **Optimizer** | `c = a + 5` (Removes redundant temporary variable) |

---

## 📁 Project Structure

* `lexer.l` — Flex rules for generating tokens.
* `parser.y` — YACC grammar rules for building the AST.
* `ast.c` / `ast.h` — Defines the tree structure and visualizes the AST.
* `semantic.c` — Manages the Symbol Table and logic checks.
* `icg.c` — Generates Three Address Code (3AC) from the AST.
* `optimizer.c` — Logic for Constant Folding and 3AC cleanup.
* `sample_input.c` — A test file containing sample code to compile.

---

## 🚀 How to Run

### Prerequisites
Ensure you have **Flex**, **YACC** (or Bison), and **GCC** added to your system PATH.

### Running Automatically (Windows)
Simply double-click the **`run.bat`** file. It handles the generation, compilation, and execution automatically.

### Running Manually
Use the following commands in your terminal:
```cmd
flex lexer.l
yacc -d parser.y
gcc lex.yy.c y.tab.c ast.c semantic.c optimizer.c icg.c main.c -o compiler.exe
compiler.exe sample_input.c
