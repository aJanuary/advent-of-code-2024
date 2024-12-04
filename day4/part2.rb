#!/usr/bin/env ruby

wordsearch = $stdin.each_line.map(&:chomp).map(&:chars)

xs = (1...(wordsearch.first.length - 1)).to_a
ys = (1...(wordsearch.length - 1)).to_a
count = xs.product(ys)
  .filter {|x, y| wordsearch[y][x] == 'A'}
  .filter do |x, y|
    # tl-br diag
    (wordsearch[y-1][x-1] == 'M' && wordsearch[y+1][x+1] == 'S') ||
      (wordsearch[y-1][x-1] == 'S' && wordsearch[y+1][x+1] == 'M')
  end.filter do |x, y|
    # tr-bl diag
    ((wordsearch[y-1][x+1] == 'M' && wordsearch[y+1][x-1] == 'S') ||
      (wordsearch[y-1][x+1] == 'S' && wordsearch[y+1][x-1] == 'M'))
  end.count

puts count