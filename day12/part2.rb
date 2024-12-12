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
    coord.y >= 0 && coord.y < height && coord.x >= 0 && coord.x < width
  end

  def each_coord
    (0...height).each do |y|
      (0...width).each do |x|
        yield Coord.new(x, y)
      end
    end
  end

  def height
    cells.size
  end

  def width
    cells[0].size
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

  Set.new(field)
end

def calc_fence_price(map, region)
  crop = map[region.first]

  # Count all the times we move from an edge to a non-edge in each direction
  # By looking only at transitions, adjactent edges effectively get merged
  # together.
  num_edges = region.map do |c|
    CARDINAL_DIRS.count do |delta|
      o = c + delta
      # Test if c has an edge in the direction of delta
      if !map.in_bounds?(o) || map[o] != crop
        # Only count this edge if the previous cell along this line wasn't an edge
        prev_c = c + Coord.new(delta.y, -delta.x)
        prev_o = prev_c + delta
        !region.include?(prev_c) || (map.in_bounds?(prev_o) && map[prev_o] == crop)
      else
        false
      end
    end
  end.sum

  num_edges * region.size
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