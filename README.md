# scheme.wasm

Scheme on wasm. The first part is a minilang which is a c-like language that compiles to wasm. Then we can implement a subset (less, only neccessary syntax forms, no macro expander) of scheme with minilang. And finally implement the rest parts in this small scheme.

## utils

* generic parsec
* monad syntax sugar

## minilang

Features:

* struct/type definitions
* global value definitions
* function definitions
* and for the statements in a function
** let (local var declaration)
** set!
** if / for / while (proper nested scope for blocks)
** plain expression evaluation (for side effects)
** return

minilang is plain scheme lists of symbols and literals, and the super simple compiler just transform it into wasm text format, call the existing wasm compiler to produce a binary module.

Implementation progress:

* transform to AST
** struct/type definitions
** pointer (type and operations) support
** statements
*** let
** plain expression to AST
** expression type annotation and implicit casts

Design on expressions, the expression itself can be mostly AST form already, in S-Exp. The first sugar maybe transform varargs form with binary operators into binary tree. For the pointers, maybe introduce some sugar to simplify the writing. etc.

## sub-scheme

...