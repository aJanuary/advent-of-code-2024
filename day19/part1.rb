#!/usr/bin/env ruby

available_towels_src, desired_patterns_src = $stdin.read.split("\n\n")

available_towels = available_towels_src.split(', ')
desired_patterns = desired_patterns_src.split("\n")

towels_re = Regexp.new('^(' + available_towels.map { |towel| Regexp.escape(towel) }.join('|') + ')*$')

num_possible = desired_patterns.count {|pattern| pattern.match?(towels_re) }
puts num_possible
