#!/usr/bin/env ruby

def is_horiz(wordsearch, x, y, needle)
  needle.chars.each_with_index.all? do |c, i|
    wordsearch.dig(y, x + i) == c
  end
end

def is_vert(wordsearch, x, y, needle)
  needle.chars.each_with_index.all? do |c, i|
    wordsearch.dig(y + i, x) == c
  end
end

def is_diag_dr(wordsearch, x, y, needle)
  needle.chars.each_with_index.all? do |c, i|
    wordsearch.dig(y + i, x + i) == c
  end
end

def is_diag_dl(wordsearch, x, y, needle)
  needle.chars.each_with_index.all? do |c, i|
    # Need to protect against negative indices, which will look from the end
    # of the array.
    x >= i && wordsearch.dig(y + i, x - i) == c
  end
end

wordsearch = $stdin.each_line.map(&:chomp).map(&:chars)

needle = 'XMAS'
xs = (0...wordsearch.first.length).to_a
ys = (0...wordsearch.length).to_a
count = xs.product(ys).map do |x, y|
  [:is_horiz, :is_vert, :is_diag_dr, :is_diag_dl].map do |method|
    (send(method, wordsearch, x, y, needle) ? 1 : 0) +
      (send(method, wordsearch, x, y, needle.reverse) ? 1 : 0)
  end.sum
end.sum

puts count