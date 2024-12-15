#!/usr/bin/env ruby

require '../lib/2d'

def rank_trail(map, pos)
  return 1 if map[pos] == 9

  Coord.cardinal_dirs.map do |d|
    new_pos = pos + d
    if !map.in_bounds?(new_pos)
      0
    elsif map[new_pos] == map[pos] + 1
      rank_trail(map, new_pos)
    else
      0
    end
  end.sum
end

map = Grid2D.new($stdin.readlines.map {|l| l.chomp.split('').map(&:to_i)})

starts = map.each_coord.filter {|pos| map[pos] == 0}
ranks = starts.map {|start| rank_trail(map, start)}
puts ranks.sum