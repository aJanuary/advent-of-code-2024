#!/usr/bin/env ruby

memory = $stdin.read.chomp
instructions = memory.scan(/(mul\((\d{1,3}),(\d{1,3})\)|don't\(\)|do\(\))/).map do |r|
  case r[0]
  when "don't()"
    { op: :dont }
  when "do()"
    { op: :do }
  else
    { op: :mul, a: r[1].to_i, b: r[2].to_i }
  end
end

result = instructions.reduce({ enabled: true, total: 0 }) do |acc, inst|
  case inst[:op]
  when :dont
    { enabled: false, total: acc[:total] }
  when :do
    { enabled: true, total: acc[:total] }
  when :mul
    if acc[:enabled]
      { enabled: acc[:enabled], total: acc[:total] + (inst[:a] * inst[:b]) }
    else
      acc
    end
  end
end

puts result[:total]