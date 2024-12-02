#!/usr/bin/env ruby

safe_reports = $stdin.each_line.map do |report_str|
  levels = report_str.split.map(&:to_i)
  diffs = levels.each_cons(2).map {|a, b| b - a}
  diffs.all? {|diff| diff.abs >= 1 && diff.abs <= 3} && (diffs.all? {|diff| diff < 0} || diffs.all? {|diff| diff > 0})
end

puts safe_reports.count(true)