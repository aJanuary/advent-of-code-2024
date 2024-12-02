#!/usr/bin/env ruby

safe_reports = $stdin.each_line.map do |report_str|
  levels = report_str.split.map(&:to_i)
  (0...levels.size).any? do |i|
    with_level_removed = levels[0...i] + levels[i+1..-1]
    dir = with_level_removed[1] - with_level_removed[0] < 0
    diffs = with_level_removed.each_cons(2).all? do |a, b|
      diff = b - a
      diff.abs >= 1 && diff.abs <= 3 && diff < 0 == dir
    end
  end
end

puts safe_reports.count(true)