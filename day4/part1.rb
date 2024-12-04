#!/usr/bin/env ruby

wordsearch = $stdin.each_line.map(&:chomp).map(&:chars)

xs = (0...wordsearch.first.length).to_a
ys = (0...wordsearch.length).to_a
deltas = [-1, 0, 1].product([-1, 0, 1]).filter {|dx, dy| dx != 0 || dy != 0}
count = xs.product(ys).map do |x, y|
  deltas.count do |dx, dy|
    'XMAS'.chars.each_with_index.all? do |c, i|
      cx = x + (dx * i)
      cy = y + (dy * i)
      cx >= 0 && cy >= 0 && wordsearch.dig(cy, cx) == c
    end
  end
end.sum

puts count