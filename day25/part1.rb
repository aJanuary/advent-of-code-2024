#!/usr/bin/env ruby

schematics_src = $stdin.read.split("\n\n")
schematics = schematics_src.map do |s|
  lines = s.lines.map(&:chomp)
  if lines[0][0] == '#'
    type = :lock
  else
    type = :key
  end
  lines = lines[1..-2]
  heights = lines.map(&:chars).transpose.map {|l| l.count('#')}
  { type: type, heights: heights }
end

keys = schematics.select {|s| s[:type] == :key}
locks = schematics.select {|s| s[:type] == :lock}

fitting = keys.product(locks).select do |key, lock|
  key[:heights].zip(lock[:heights]).all? {|k, l| k + l <= 5}
end

puts fitting.count