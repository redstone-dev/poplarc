import gleam/dict

pub type Instruction

pub type Register =
  BitArray

pub type StackFrame =
  dict.Dict(Int, Register)

pub type Stack =
  List(StackFrame)

pub fn reg_set(frame: StackFrame, register: Int, value: BitArray) {
  dict.upsert(frame, register, fn(_) { value })
}

pub fn reg_get(frame: StackFrame, register: Int) {
  dict.get(frame, register)
}

pub type VM {
  VM(stack: Stack, globals: StackFrame)
}

pub type Program =
  List(Instruction)
