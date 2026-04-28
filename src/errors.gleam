import gleam/int.{to_string}
import gleam/io.{println_error}

pub type Span {
  Span(start: Int, end: Int)
}

pub fn span_to_string(span: Span) {
  to_string(span.start) <> ":" <> to_string(span.end)
}

pub type CompilerMessage {
  CompilerMessage(kind: CompilerMessage)
  CompilerNote(String, span: Span)
  CompilerWarning(String, span: Span)
  CompilerError(String, span: Span)
}

pub fn colour(string, fg, bg) -> String {
  "\u{1B}[3"
  <> to_string(fg)
  <> ";4"
  <> to_string(bg)
  <> "m"
  <> string
  <> "\u{1B}[0m"
}

pub fn print(message: CompilerMessage, filename: String) {
  println_error("In " <> colour(filename, 3, 0) <> ":")
  io.print_error("╰ ")
  case message {
    CompilerNote(message, span) -> {
      println_error(
        colour("Note", 6, 0)
        <> ": "
        <> message
        <> " ("
        <> span_to_string(span)
        <> ")",
      )
    }
    CompilerWarning(message, span) -> {
      println_error(
        colour("Warning", 3, 0)
        <> ": "
        <> message
        <> " ("
        <> span_to_string(span)
        <> ")",
      )
    }
    CompilerError(message, span) -> {
      println_error(
        colour("Error", 1, 0)
        <> ": "
        <> message
        <> " ("
        <> span_to_string(span)
        <> ")",
      )
    }
    _ -> panic as "Passed invalid variant 'CompilerMessage' to errors.print"
  }
}
