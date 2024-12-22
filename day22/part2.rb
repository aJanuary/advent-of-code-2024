#!/usr/bin/env ruby

require 'set'

def gen_next(n)
  n = (n ^ (n * 64)) % 16777216
  n = (n ^ (n / 32)) % 16777216
  n = (n ^ (n * 2048)) % 16777216
  n
end

seeds = $stdin.readlines.map(&:to_i)

prev_price = seeds.map {|seed| seed.to_s[-1].to_i}
ns = seeds.map {|seed| seed}
windows = seeds.map {|seed| []}
prices_at_window = Hash.new {|h, k| h[k] = {}}
2000.times do |a|
  ns.each_with_index do |n, i|
    ns[i] = gen_next(n)
    price = ns[i].to_s[-1].to_i
    price_diff = price - prev_price[i]
    prev_price[i] = price
    windows[i] << price_diff
    window_key = windows[i][-4..-1]&.join(',')
    if window_key && !prices_at_window[window_key].key?(i)
      prices_at_window[window_key][i] = price
    end
  end
end

puts prices_at_window.map {|_, prices| prices.values.sum}.max
