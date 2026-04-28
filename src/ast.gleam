import errors.{type CompilerMessage}
import gleam/list
import gleam/result

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
  tags: [],
)

/// Walks an AST. given a handler it executes it on every node
/// Returns the first error
pub fn walk(
  nodes: List(Node),
  handler: fn(Node) -> Result(Nil, #(CompilerMessage, String)),
) -> Result(Nil, #(CompilerMessage, String)) {
  walk_tail(nodes, handler)
}

// Thanks to @littlelily on discord for helping out :3
pub fn walk_tail(
  nodes: List(Node),
  handler: fn(Node) -> Result(Nil, #(CompilerMessage, String)),
) -> Result(Nil, #(CompilerMessage, String)) {
  case nodes {
    [head, ..nodes] -> {
      case handler(head) {
        Ok(Nil) -> walk_tail(nodes, handler)
        e -> e
      }
    }
    [] -> Ok(Nil)
  }
}

/// Function to validate the AST
pub fn validate(ast: Node) -> List(CompilerMessage) {
  todo
}
