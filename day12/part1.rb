#!/usr/bin/env ruby

require 'set'
require '../lib/2d'

def find_coords_in_field(map, c)
  seen = Set[c]
  crop = map[c]
  field = [c]
  idx = 0

  until idx == field.size
    Coord.cardinal_dirs.each do |delta|
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
    Coord.cardinal_dirs.count do |delta|
      o = c + delta
      !map.in_bounds?(o) || map[o] != map[c]
    end
  end.sum

  region.size * perimeter
end

map = Grid2D.new($stdin.readlines.map(&:chomp).map(&:chars))

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