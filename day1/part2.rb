#!/usr/bin/env ruby

left, right = $stdin.each_line.map {|l| l.split.map(&:to_i) }.transpose
total = left.map {|x| x * right.count(x)}.sum

puts total