#!/usr/bin/env ruby

memory = $stdin.read.chomp
instructions = memory.scan(/mul\((\d{1,3}),(\d{1,3})\)/).map do |a, b|
  [a.to_i, b.to_i]
end
result = instructions.map {|a, b| a * b}.sum
puts result