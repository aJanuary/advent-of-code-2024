#!/usr/bin/env ruby

games = $stdin.read.split("\n\n").map do |game_src|
  button_a, button_b, prize = game_src.split("\n").map do |line|
    line.scan(/\d+/)
  end
  {
    button_a: {
      x: button_a[0].to_i,
      y: button_a[1].to_i
    },
    button_b: {
      x: button_b[0].to_i,
      y: button_b[1].to_i
    },
    prize: {
      x: prize[0].to_i + 10000000000000,
      y: prize[1].to_i + 10000000000000
    }
  }
end

tokens = games.map do |game|
  slope_a = Rational(game[:button_a][:y], game[:button_a][:x])
  slope_b = Rational(game[:button_b][:y], game[:button_b][:x])
  c = game[:prize][:y] - slope_b*game[:prize][:x]
  intersection_x = Rational(c, slope_a - slope_b)

  num_as = intersection_x / game[:button_a][:x]
  next 0 if num_as.denominator != 1
  num_bs = (game[:prize][:x] - (num_as * game[:button_a][:x])) / game[:button_b][:x]
  next 0 if num_bs.denominator != 1
  ((num_as * 3) + num_bs).to_i
end

puts tokens.sum