#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
end

Guard = Struct.new(:pos, :dir)

guard = nil
obstacles = Set.new
lines = $stdin.readlines
height = lines.length
width = lines[0].chomp.length
lines.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |c, x|
    if c == '#'
      obstacles << Coord.new(x, y)
    elsif c != '.'
      guard = Guard.new(Coord.new(x, y), Coord.new(0, -1))
    end
  end
end

visited = Set.new
while guard.pos.x >= 0 && guard.pos.x < width && guard.pos.y >= 0 && guard.pos.y < height
  new_pos = guard.pos + guard.dir
  
  if obstacles.include?(new_pos)
    guard.dir = Coord.new(-guard.dir.y, guard.dir.x)
  else
    guard.pos = new_pos
  end

  visited << guard.pos
end

puts visited.size