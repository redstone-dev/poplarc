import cli
import errors
import gleam/io

pub fn main() -> Nil {
  errors.print(errors.CompilerNote("mrrrp~~", errors.Span(0, 0)), "example")
}
