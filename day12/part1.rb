#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end

  def to_s
    "(#{x},#{y})"
  end

  def inspect
    to_s
  end
end

Grid = Struct.new(:cells) do
  def [](coord)
    cells[coord.y][coord.x]
  end

  def in_bounds?(coord)
    coord.y >= 0 && coord.y < cells.size && coord.x >= 0 && coord.x < cells[0].size
  end

  def each_coord
    (0...cells.size).each do |y|
      (0...cells[0].size).each do |x|
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

def find_coords_in_field(map, c)
  seen = Set[c]
  crop = map[c]
  field = [c]
  idx = 0

  until idx == field.size
    CARDINAL_DIRS.each do |delta|
      o = field[idx] + delta
      next unless map.in_bounds?(o)
      next unless seen.add?(o)
      next unless map[o] == crop
      field << o
    end
    idx += 1
  end

  field
end

def calc_fence_price(map, region)
  perimeter = region.map do |c|
    CARDINAL_DIRS.count do |delta|
      o = c + delta
      !map.in_bounds?(o) || map[o] != map[c]
    end
  end.sum

  region.size * perimeter
end

map = Grid.new($stdin.readlines.map(&:chomp).map(&:chars))

visited = Set.new
regions = []
map.each_coord do |c|
  next if visited.include?(c)

  region = find_coords_in_field(map, c)
  regions << region
  visited += region
end

total_fence_cost = regions.map {|r| calc_fence_price(map, r)}.sum

puts total_fence_cost