#!/usr/bin/env ruby

safe_reports = $stdin.each_line.map do |report_str|
  levels = report_str.split.map(&:to_i)
  dir = levels[1] - levels[0] < 0
  diffs = levels.each_cons(2).all? do |a, b|
    diff = b - a
    diff.abs >= 1 && diff.abs <= 3 && diff < 0 == dir
  end
end

puts safe_reports.count(true)