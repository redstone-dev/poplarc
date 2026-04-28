import ast
import gleam/string_tree
import simplifile

fn codegen_test() {
  ast.test_ast
}
// create a C source file
// cursor position
// keep track of brackets
// walk the ast, each node:
// match on node and generate corresponding C code
// where do move semantics/borrow checker/effects/lifetimes fit in? no clue
// have to create multiple string trees, merge them together at the end
// then write them to file
