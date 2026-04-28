import errors.{type CompilerMessage}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string_tree

pub type NodeKind {
  Module

  FnDecl
  VarDecl
  EffectDecl
  TypeDecl
  Expression

  Identifier(String)
  IntValue(Int)
  FloatValue(Float)
  StringValue(String)
  BoolValue(Bool)
  ByteValue(Int)

  Add
  Subtract
  Multiply
  Divide
  Modulo

  Not
  And
  Or
  Xor
  Equal
  GreaterThan
  LessThan

  FnCall
  EffectCall
  Constructor

  Match
  MatchCase
  Pattern

  TypeAnnotation
}

pub type Tag {
  Type(Type)
  Effect(String)
  Value(String)
  Name(String)
  ReturnType(Type)
  UseEffect(String)
  TypeParams(List(Type))
  FnArgs(List(#(String, Type)))
  FnNoArgs
  NoEffect
}

pub type Type {
  PrimitiveInt
  PrimitiveString
  PrimitiveFloat
  PrimitiveBool
  PrimitiveByte
  PrimitiveTuple(List(Type))
  PrimitiveNil
  UserType(String)
  GenericUserType(String, params: List(Type))
}

pub type Node {
  Node(NodeKind, List(Node), tags: List(Tag))
  Leaf(NodeKind, tags: List(Tag))
}

pub const statements = [FnDecl, VarDecl, TypeDecl, EffectDecl]

pub const test_ast = Node(
  Module,
  [
    Node(
      TypeDecl,
      [
        Leaf(Identifier("Bar"), tags: []),
        Leaf(Identifier("Baz"), tags: []),
      ],
      tags: [Name("Foo")],
    ),
    Node(
      FnDecl,
      [
        Node(
          Expression,
          [
            Node(
              Add,
              [
                Leaf(Identifier("qux"), tags: []),
                Leaf(IntValue(5), tags: []),
              ],
              tags: [],
            ),
          ],
          tags: [],
        ),
      ],
      tags: [
        Name("exampleFunc"),
        ReturnType(PrimitiveInt),
        FnArgs([#("qux", PrimitiveInt)]),
      ],
    ),
    Node(
      FnDecl,
      [
        Node(
          Expression,
          [
            Node(
              EffectCall,
              [
                Leaf(Identifier("stdout"), tags: []),
                Leaf(StringValue("Hello world!"), tags: []),
              ],
              tags: [Name("write")],
            ),
          ],
          tags: [],
        ),
      ],
      tags: [Name("main"), ReturnType(PrimitiveNil), NoEffect, FnNoArgs],
    ),
  ],
  tags: [Name("example.pop")],
)

/// Walks an AST. given a handler it executes it on every node
/// Returns the first error
pub fn walk(
  nodes: List(Node),
  handler: fn(Node) -> #(CompilerMessage, String),
) -> #(CompilerMessage, String) {
  walk_loop(nodes, handler)
}

// Thanks to @littlelily on discord for helping out :3
pub fn walk_loop(
  nodes: List(Node),
  handler: fn(Node) -> #(CompilerMessage, String),
) -> #(CompilerMessage, String) {
  case nodes {
    [head, ..nodes] -> {
      case handler(head) {
        #(errors.CompilerOk, _) -> walk_loop(nodes, handler)
        e -> e
      }
    }
    [] -> #(errors.CompilerOk, "")
  }
}

pub fn has_tag(node: Node, tag: Tag) -> Bool {
  case node {
    Node(_, _, tags) -> {
      list.contains(tags, tag)
    }
    Leaf(_, tags) -> {
      list.contains(tags, tag)
    }
  }
}

pub fn expect(f: Bool, error: errors.CompilerMessage) {
  case f {
    True -> error
    False -> errors.CompilerOk
  }
}

/// Function to validate the AST
pub fn validate(ast: Node, filename: String) -> #(CompilerMessage, String) {
  let assert Node(_, ast_children, _) = ast
  let span_todo = errors.Span(0, 0)
  walk(ast_children, fn(node) {
    case node {
      Node(kind, children, tags) -> {
        case kind {
          Module -> {
            #(
              expect(
                has_tag(node, Name),
                errors.CompilerError(
                  "Expected `Module` to have a `Name` tag",
                  span_todo,
                ),
              ),
              filename,
            )
          }
          FnDecl -> {
            todo
          }
          VarDecl -> {
            todo
          }
          EffectDecl -> {
            todo
          }
          TypeDecl -> {
            todo
          }
          Expression -> {
            todo
          }

          Add -> {
            todo
          }
          Subtract -> {
            todo
          }
          Multiply -> {
            todo
          }
          Divide -> {
            todo
          }
          Modulo -> {
            todo
          }

          Not -> {
            todo
          }
          And -> {
            todo
          }
          Or -> {
            todo
          }
          Xor -> {
            todo
          }
          Equal -> {
            todo
          }
          GreaterThan -> {
            todo
          }
          LessThan -> {
            todo
          }

          FnCall -> {
            todo
          }
          EffectCall -> {
            todo
          }
          Constructor -> {
            todo
          }

          Match -> {
            todo
          }
          MatchCase -> {
            todo
          }
          Pattern -> {
            todo
          }

          TypeAnnotation -> {
            todo
          }

          _ -> #(
            errors.CompilerError(
              "Invalid node type! Whatever it is must be a Leaf",
              errors.Span(0, 0),
            ),
            filename,
          )
        }
      }
      Leaf(kind, tags) -> {
        todo
      }
    }
  })
}
