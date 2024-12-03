#!/usr/bin/env ruby

memory = $stdin.read.chomp
instructions = memory.scan(/(mul\((\d{1,3}),(\d{1,3})\)|don't\(\)|do\(\))/).map do |r|
  if r[0] == "don't()"
    { op: :dont }
  elsif r[0] == "do()"
    { op: :do }
  else
    { op: :mul, a: r[1].to_i, b: r[2].to_i }
  end
end

result = instructions.reduce({ enabled: true, total: 0 }) do |acc, inst|
  if inst[:op] == :do
    { enabled: true, total: acc[:total] }
  elsif inst[:op] == :dont
    { enabled: false, total: acc[:total] }
  elsif acc[:enabled]
    { enabled: acc[:enabled], total: acc[:total] + (inst[:a] * inst[:b]) }
  else
    acc
  end
end

puts result[:total]