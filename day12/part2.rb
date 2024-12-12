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

  field
end

def calc_fence_price(map, region)
  crop = map[region[0]]

  xs = region.map(&:x)
  ys = region.map(&:y)
  x_range = xs.min..xs.max
  y_range = ys.min..ys.max

  num_edges = 0

  y_range.each do |y|
    walking_north_edge = false
    walking_south_edge = false
  
    x_range.each do |x|
      c = Coord.new(x, y)
      if region.include?(c)
        up_c = c + Coord.new(0, -1)
        down_c = c + Coord.new(0, 1)

        has_north_edge = !map.in_bounds?(up_c) || map[up_c] != crop
        has_south_edge = !map.in_bounds?(down_c) || map[down_c] != crop

        num_edges += 1 if has_north_edge && !walking_north_edge
        num_edges += 1 if has_south_edge && !walking_south_edge

        walking_north_edge = has_north_edge
        walking_south_edge = has_south_edge
      else
        walking_north_edge = false
        walking_south_edge = false
      end
    end
  end

  x_range.each do |x|
    walking_west_edge = false
    walking_east_edge = false
  
    y_range.each do |y|
      c = Coord.new(x, y)
      if region.include?(c)
        left_c = c + Coord.new(-1, 0)
        right_c = c + Coord.new(1, 0)

        has_west_edge = !map.in_bounds?(left_c) || map[left_c] != crop
        has_east_edge = !map.in_bounds?(right_c) || map[right_c] != crop

        num_edges += 1 if has_west_edge && !walking_west_edge
        num_edges += 1 if has_east_edge && !walking_east_edge

        walking_west_edge = has_west_edge
        walking_east_edge = has_east_edge
      else
        walking_west_edge = false
        walking_east_edge = false
      end
    end
  end

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