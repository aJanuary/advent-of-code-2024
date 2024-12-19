#!/usr/bin/env ruby

def count_possible_patterns(pattern, available_towels, cache = {})
  return cache[pattern] if cache.key?(pattern)

  return 1 if pattern.length == 0

  possible_patterns = available_towels.select do |towel|
    pattern.start_with?(towel)
  end

  return 0 if possible_patterns.empty?

  res = possible_patterns.map do |towel|
    count_possible_patterns(pattern[towel.length..-1], available_towels, cache)
  end.sum
  cache[pattern] = res
  res
end

available_towels_src, desired_patterns_src = $stdin.read.split("\n\n")

available_towels = available_towels_src.split(', ')
desired_patterns = desired_patterns_src.split("\n")

num_possible = desired_patterns.map do |pattern|
  count_possible_patterns(pattern, available_towels)
end.sum
puts num_possible
