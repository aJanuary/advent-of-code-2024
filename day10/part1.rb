#!/usr/bin/env ruby

Coord = Struct.new(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
end

Grid = Struct.new(:map) do
  def [](pos)
    map[pos.y][pos.x]
  end

  def []=(pos, value)
    map[pos.y][pos.x] = value
  end

  def in_bounds?(pos)
    pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height
  end

  def height
    map.size
  end

  def width
    map[0].size
  end

  def each_pos(&block)
    return enum_for(:each_pos) unless block_given?

    height.times do |y|
      width.times do |x|
        yield Coord.new(x, y)
      end
    end
  end
end

CARDINAL_DIRS = [
  Coord.new(0, -1),
  Coord.new(1, 0),
  Coord.new(0, 1),
  Coord.new(-1, 0)
]

def find_route_ends(map, pos)
  return [pos] if map[pos] == 9

  CARDIANL_DIRS.flat_map do |d|
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

map = Grid.new($stdin.readlines.map {|l| l.chomp.split('').map(&:to_i)})

starts = map.each_pos.filter {|pos| map[pos] == 0}
scores = starts.map {|start| find_route_ends(map, start).count}
puts scores.sum