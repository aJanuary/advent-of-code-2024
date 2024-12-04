#!/usr/bin/env ruby

def count_horiz(wordsearch, word)
  wordsearch.map do |row|
    row.each_cons(word.size).count {|slice| slice.join == word}
  end.sum
end

def count_vert(wordsearch, word)
  count_horiz(wordsearch.transpose, word)
end

def count_diag_dr(wordsearch, word)
  count = 0
  (0..(wordsearch.length - word.length)).each do |start_y|
    (0..(wordsearch[0].length - word.length)).each do |start_x|
      count += 1 if word.chars.each_with_index.all? do |c, i|
        wordsearch[start_y + i][start_x + i] == c
      end
    end
  end
  count
end

def count_diag_dl(wordsearch, word)
  count = 0
  (0..(wordsearch.length - word.length)).each do |start_y|
    ((word.length-1)..wordsearch[0].length).each do |start_x|
      count += 1 if word.chars.each_with_index.all? do |c, i|
        wordsearch[start_y + i][start_x - i] == c
      end
    end
  end
  count
end

wordsearch = $stdin.each_line.map(&:chomp).map(&:chars)

total = count_horiz(wordsearch, 'XMAS') +
  count_horiz(wordsearch, 'SAMX') +
  count_vert(wordsearch, 'XMAS') +
  count_vert(wordsearch, 'SAMX') +
  count_diag_dr(wordsearch, 'XMAS') +
  count_diag_dr(wordsearch, 'SAMX') +
  count_diag_dl(wordsearch, 'XMAS') +
  count_diag_dl(wordsearch, 'SAMX')

puts total