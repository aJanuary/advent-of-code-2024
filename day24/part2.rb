#!/usr/bin/env ruby

registers_src, gates_src = $stdin.read.split("\n\n")
registers = registers_src.lines.map do |line|
  name, value = line.scan(/([^:]+): (\d+)/)[0]
  [name, value.to_i]
end.to_h

gates = gates_src.lines.map do |line|
  input1, type, input2, output = line.chomp.scan(/([^ ]+) (XOR|AND|OR) ([^ ]+) -> ([^ ]+)/)[0]
  [output, { inputs: [input1, input2], type: type.downcase.to_sym }]
end.to_h

def is_full_adder?(gates, s)
  return false if gates[s][:type] != :xor
  
  i1, xor1 = gates.find do |output, gate|
    gates[s][:inputs].include?(output) &&
      gate[:type] == :xor &&
      gate[:inputs].all? {|i| i.start_with?('x') || i.start_with?('y')}
  end || [nil, nil]
  return false unless xor1

  a = xor1[:inputs][0]
  b = xor1[:inputs][1]
  c_in = gates[s][:inputs].find {|i| i != i1}

  and1_output, and1 = gates.find do |output, gate|
    gate[:type] == :and &&
      gate[:inputs].include?(i1) &&
      gate[:inputs].include?(c_in)
  end || [nil, nil]
  return false unless and1

  and2_output, and2 = gates.find do |output, gate|
    gate[:type] == :and &&
      gate[:inputs].include?(a) &&
      gate[:inputs].include?(b)
  end || [nil, nil]
  return false unless and2

  or1 = gates.find do |output, gate|
    gate[:type] == :or &&
      gate[:inputs].include?(and1_output) &&
      gate[:inputs].include?(and2_output)
  end
  return false unless or1

  true
end

broken_adders = (1...45).map {|i| "z#{i.to_s.rjust(2, '0')}"}.select do |z_reg|
  !is_full_adder?(gates, z_reg)
end

working_swaps = Hash.new {|h, k| h[k] = []}

candidates = gates.keys.dup
swaps = candidates.product(candidates).filter {|a, b| !a.start_with?('z') || !b.start_with?('z')}
swaps.each do |a, b|
  new_gates = gates.dup
  new_gates[a], new_gates[b] = new_gates[b], new_gates[a]
  broken_adders.each do |broken_adder|
    if is_full_adder?(new_gates, broken_adder)
      working_swaps[broken_adder] << [a, b].sort
    end
  end
end

swaps_without_dups = working_swaps.values[0].product(*working_swaps.values[1..-1]).filter do |swaps|
  swaps.flatten.uniq.length == swaps.flatten.length
end.first

puts swaps_without_dups.flatten.sort.join(',')