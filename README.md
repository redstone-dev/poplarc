# `poplarc`

Compiler for a programming language I'm working on, called Poplar. The compiler is called `poplarc` and written in Gleam. Syntax examples are available in [examples](/examples) if you want to see them.

## Status
`poplarc` is __NOT FUNCTIONAL__ right now. It is still in the extremely early stages of development. Currently, AST data structures/validation and code generation are the focus. After that, a recursive descent parser will be made and the language expanded from there.

## The Language
Poplar is an immutable functional systems programming language following a similar memory management model to Rust (i.e., affine types and borrow checking). It also has an effect system _à la_ Koka or Effekt. It draws from many languages, notably including Rust, Erlang, Haskell, Koka, and Effekt. The idea is for software _never to fail_ through extensive static analysis, and when it does, have resiliency.

## History
The idea for Poplar and its compiler came about in early-mid 2026 following a train of shower thoughts along the lines of, "what if Erlang, but no BEAM". I finally decided to write the compiler in late April of that year.
