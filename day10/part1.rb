#!/usr/bin/env ruby

require '../lib/2d'

def find_route_ends(map, pos)
  return [pos] if map[pos] == 9

  Coord.cardinal_dirs.flat_map do |d|
    new_pos = pos + d
    if !map.in_bounds?(new_pos)
      []
    elsif map[new_pos] == map[pos] + 1
      find_route_ends(map, new_pos)
    else
      []
    end
  end.uniq
end

map = Grid2D.new($stdin.readlines.map {|l| l.chomp.split('').map(&:to_i)})

starts = map.each_coord.filter {|pos| map[pos] == 0}
scores = starts.map {|start| find_route_ends(map, start).count}
puts scores.sum