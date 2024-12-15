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
    dx = a.x - b.x
    dy = a.y - b.y
    gcd = dx.gcd(dy)
    dx /= gcd
    dy /= gcd

    pos_diag = (0..).lazy.map do |mag|
      Coord.new(a.x + (mag * dx), a.y + (mag * dy))
    end.take_while do |c|
      c.x >= 0 && c.x < width && c.y >= 0 && c.y < height
    end

    neg_diag = (0..).lazy.map do |mag|
      Coord.new(a.x - (mag * dx), a.y - (mag * dy))
    end.take_while do |c|
      c.x >= 0 && c.x < width && c.y >= 0 && c.y < height
    end

    pos_diag.to_a + neg_diag.to_a
  end
end.uniq

puts positions.count