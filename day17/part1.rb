#!/usr/bin/env ruby

def decode_combo_operand(operand, registers)
  if operand <= 3
    operand
  else
    registers[operand - 4]
  end
end

registers_src, program_src = $stdin.read.split("\n\n")
registers = registers_src.scan(/\d+/).map(&:to_i)
program = program_src.scan(/\d+/).map(&:to_i)
instr_ptr = 0
output = []

while instr_ptr < program.size
  adv_ptr = true
  instr = program[instr_ptr]
  operand = program[instr_ptr + 1]
  case instr
  when 0
    # adv
    numerator = registers[0]
    denominator = 2 ** decode_combo_operand(operand, registers)
    registers[0] = numerator / denominator
  when 1
    # bxl
    registers[1] ^= operand
  when 2
    # bst
    registers[1] = decode_combo_operand(operand, registers) % 8
  when 3
    # jnz
    if registers[0] != 0
      instr_ptr = operand
      adv_ptr = false
    end
  when 4
    # bxc
    registers[1] = registers[1] ^ registers[2]
  when 5
    # out
    output << decode_combo_operand(operand, registers) % 8
  when 6
    # bdv
    numerator = registers[0]
    denominator = 2 ** decode_combo_operand(operand, registers)
    registers[1] = numerator / denominator
  when 7
    # cdv
    numerator = registers[0]
    denominator = 2 ** decode_combo_operand(operand, registers)
    registers[2] = numerator / denominator
  end

  instr_ptr += 2 if adv_ptr
end

puts output.join(",")