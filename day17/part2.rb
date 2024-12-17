#!/usr/bin/env ruby

require 'set'

def decode_combo_operand(operand, registers)
  if operand <= 3
    operand
  else
    registers[operand - 4]
  end
end

def run(program, a)
  registers = [a, 0, 0]
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
  output
end

def find_a_register(program, target_output)
  queue = [0]
  while !queue.empty?
    cur = queue.shift
    last_digits = (0...8).map {|x| (cur * 8) + x}.filter do |a|
      output = run(program, a)
      return a if output == target_output
      offset = a.to_s(8).length
      output[-offset] == target_output[-offset]
    end
    queue += last_digits
  end
end

_, program_src = $stdin.read.split("\n\n")
program = program_src.scan(/\d+/).map(&:to_i)
puts find_a_register(program, program)
