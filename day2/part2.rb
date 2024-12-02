#!/usr/bin/env ruby

safe_reports = $stdin.each_line.each_with_index.map do |report_str, i|
  levels = report_str.split.map(&:to_i)
  (0...levels.size).any? do |i|
    with_level_removed = levels[0...i] + levels[i+1..-1]
    diffs = with_level_removed.each_cons(2).map {|a, b| b - a}
    diffs.all? {|diff| diff.abs >= 1 && diff.abs <= 3} && (diffs.all? {|diff| diff < 0} || diffs.all? {|diff| diff > 0})
  end
end

puts safe_reports.count(true)