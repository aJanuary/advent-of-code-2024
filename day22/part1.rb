#!/usr/bin/env ruby

seeds = $stdin.readlines.map(&:to_i)

after_2000_iters = seeds.map do |n|
  2000.times do
    n = (n ^ (n * 64)) % 16777216
    n = (n ^ (n / 32)) % 16777216
    n = (n ^ (n * 2048)) % 16777216
  end
  n
end

puts after_2000_iters.sum