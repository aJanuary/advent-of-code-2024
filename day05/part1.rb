#!/usr/bin/env ruby

ordering_str, update_str = $stdin.read.split("\n\n")
ordering_rules = ordering_str
  .split("\n").map {|line| line.split("|").map(&:to_i)}
  .group_by {|k, v| k}
  .transform_values {|v| v.map(&:last).flatten}
updates = update_str.split("\n").map {|line| line.split(",").map(&:to_i)}

answer = updates.filter_map do |update|
  sorted = update.sort {|a, b| (ordering_rules[a] || []).include?(b) ? -1 : 1}
  next if sorted != update
  sorted[sorted.size / 2]
end.sum
puts answer