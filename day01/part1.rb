#!/usr/bin/env ruby

left, right = $stdin.each_line.map {|l| l.split.map(&:to_i) }.transpose
total = left.sort.zip(right.sort).map {|x, y| (x - y).abs}.sum

puts total