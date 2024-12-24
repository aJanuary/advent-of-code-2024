#!/usr/bin/env ruby

def resolve_register(r, registers, gates)
  unless registers.key?(r)
    gate = gates[r]
    inputs = gate[:inputs].map {|i| resolve_register(i, registers, gates)}
    registers[r] = case gate[:type]
    when :and
      inputs[0] & inputs[1]
    when :or
      inputs[0] | inputs[1]
    when :xor
      inputs[0] ^ inputs[1]
    else
      raise "Unknown gate type: #{gate[:type]}"
    end
  end

  registers[r]
end

registers_src, gates_src = $stdin.read.split("\n\n")
registers = registers_src.lines.map do |line|
  name, value = line.scan(/([^:]+): (\d+)/)[0]
  [name, value.to_i]
end.to_h

gates = gates_src.lines.map do |line|
  input1, type, input2, output = line.chomp.scan(/([^ ]+) (XOR|AND|OR) ([^ ]+) -> ([^ ]+)/)[0]
  [output, { inputs: [input1, input2], type: type.downcase.to_sym }]
end.to_h

all_z_registers = (registers.keys + gates.keys).select {|k| k.start_with?('z')}.sort.reverse
binary = all_z_registers.map {|r| resolve_register(r, registers, gates)}
result = binary.join.to_i(2)
puts result