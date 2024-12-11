#!/usr/bin/env ruby

def memoize(func)
  orig_func = method(func)
  cache = {}
  define_method(func) do |*args|
    return cache[args] if cache.key?(args)

    cache[args] = orig_func.call(*args)
  end
end

def count_stones_after_blinks(stone, num_blinks)
  return 1 if num_blinks.zero?

  if stone == 0
    count_stones_after_blinks(1, num_blinks - 1)
  else
    stone_str = stone.to_s
    if stone_str.length.even?
      left = stone_str[0, stone_str.length / 2].to_i
      right = stone_str[stone_str.length / 2, stone_str.length].to_i
      count_stones_after_blinks(left, num_blinks - 1) +
        count_stones_after_blinks(right, num_blinks - 1)
    else
      count_stones_after_blinks(stone * 2024, num_blinks - 1)
    end
  end
end

memoize(:count_stones_after_blinks)

stones = $stdin.read.chomp.split.map(&:to_i)
count = stones.map {|stone| count_stones_after_blinks(stone, 25)}.sum
puts count