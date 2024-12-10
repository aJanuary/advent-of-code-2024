#!/usr/bin/env ruby

Coord = Struct.new(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
end

def rank_trail(map, pos)
  return 1 if map[pos.y][pos.x] == 9

  [
    Coord.new(0, -1),
    Coord.new(1, 0),
    Coord.new(0, 1),
    Coord.new(-1, 0)
  ].map do |d|
    new_pos = pos + d
    if new_pos.x < 0 || new_pos.x >= map[0].size || new_pos.y < 0 || new_pos.y >= map.size
      0
    elsif map[new_pos.y][new_pos.x] == map[pos.y][pos.x] + 1
      rank_trail(map, new_pos)
    else
      0
    end
  end.sum
end

map = $stdin.readlines.map {|l| l.chomp.split('').map(&:to_i)}

starts = map.each_with_index.flat_map do |row, y|
  row.each_with_index.select {|cell, x| cell == 0}.map {|cell, x| Coord.new(x, y)}
end

ranks = starts.map {|start| rank_trail(map, start)}
puts ranks.sum