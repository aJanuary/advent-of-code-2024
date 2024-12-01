#!/usr/bin/env ruby

left, right = $stdin.each_line.map {|l| l.chomp.split(/\s+/).map(&:to_i) }.transpose
total = left.map {|x| x * right.count(x)}.sum
puts total