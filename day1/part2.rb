#!/usr/bin/env ruby

left, right = $stdin.each_line.map {|l| l.split.map(&:to_i) }.transpose
tally = right.tally
total = left.map {|x| x * (tally[x] || 0)}.sum

puts total