#!/usr/bin/env ruby

Coord = Struct.new(:x, :y)

lines = $stdin.readlines
height = lines.size
width = lines[0].chomp.size
antenna = lines.each_with_index.flat_map do |line, y|
  line.chomp.chars.each_with_index.filter_map do |freq, x|
    [freq, Coord.new(y, x)] if freq != '.'
  end
end.group_by(&:first).transform_values { |v| v.map(&:last) }

positions = antenna.flat_map do |freq, coords|
  coords.combination(2).flat_map do |a, b|
    [
      Coord.new(a.x + (a.x - b.x), a.y + (a.y - b.y)),
      Coord.new(b.x + (b.x - a.x), b.y + (b.y - a.y))
    ].filter {|c| c.x >= 0 && c.x < width && c.y >= 0 && c.y < height}
  end
end

puts positions.uniq.count