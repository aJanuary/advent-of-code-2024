#!/usr/bin/env ruby

wordsearch = $stdin.each_line.map(&:chomp).map(&:chars)

count = 0
wordsearch.each_with_index do |row, y|
  next if y == 0 || y == wordsearch.length - 1

  row.each_with_index do |c, x|
    next if x == 0 || x == row.length - 1

    if c == 'A'
      dr_diag = (wordsearch[y-1][x-1] == 'M' && wordsearch[y+1][x+1] == 'S') ||
        (wordsearch[y-1][x-1] == 'S' && wordsearch[y+1][x+1] == 'M')
      dl_diag = (wordsearch[y-1][x+1] == 'M' && wordsearch[y+1][x-1] == 'S') ||
        (wordsearch[y-1][x+1] == 'S' && wordsearch[y+1][x-1] == 'M')
      count += 1 if dr_diag && dl_diag
    end
  end
end

puts count