#!/usr/bin/env ruby

ordering_str, update_str = $stdin.read.split("\n\n")
ordering_rules = ordering_str
  .split("\n").map {|line| line.split("|").map(&:to_i)}
  .group_by {|k, v| k}
  .transform_values {|v| v.map(&:last).flatten}
updates = update_str.split("\n").map {|line| line.split(",").map(&:to_i)}

in_correct_order = updates.filter do |update|
  (0...update.size).all? do |i|
    i.downto(0) do |j|
      break false if (ordering_rules[update[i]] || []).include?(update[j])
    end
  end
end

answer = in_correct_order.map {|u| u[u.size / 2]}.sum
puts answer