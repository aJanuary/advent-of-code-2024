#!/usr/bin/env ruby

ordering_str, update_str = $stdin.read.split("\n\n")
ordering_rules = ordering_str
  .split("\n").map {|line| line.split("|").map(&:to_i)}
  .group_by {|k, v| k}
  .transform_values {|v| v.map(&:last).flatten}
updates = update_str.split("\n").map {|line| line.split(",").map(&:to_i)}

sorted = updates.map do |update|
  update.sort do |a, b|
    if (ordering_rules[a] || []).include?(b)
      -1
    elsif (ordering_rules[b] || []).include?(a)
      1
    else
      0
    end
  end
end

corrected_updates = sorted.filter {|line| !updates.include?(line)}
answer = corrected_updates.map {|u| u[u.size / 2]}.sum
puts answer