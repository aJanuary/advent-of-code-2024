#!/usr/bin/env ruby

Coord = Struct.new(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
end

def find_route_ends(map, pos)
  return [pos] if map[pos.y][pos.x] == 9

  [
    Coord.new(0, -1),
    Coord.new(1, 0),
    Coord.new(0, 1),
    Coord.new(-1, 0)
  ].flat_map do |d|
    new_pos = pos + d
    if new_pos.x < 0 || new_pos.x >= map[0].size || new_pos.y < 0 || new_pos.y >= map.size
      []
    elsif map[new_pos.y][new_pos.x] == map[pos.y][pos.x] + 1
      find_route_ends(map, new_pos)
    else
      []
    end
  end.uniq
end

map = $stdin.readlines.map {|l| l.chomp.split('').map(&:to_i)}

starts = map.each_with_index.flat_map do |row, y|
  row.each_with_index.select {|cell, x| cell == 0}.map {|cell, x| Coord.new(x, y)}
end

scores = starts.map {|start| find_route_ends(map, start).count}
puts scores.sum