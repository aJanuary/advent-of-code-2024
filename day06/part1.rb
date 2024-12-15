#!/usr/bin/env ruby

require 'set'
require '../lib/2d'

Guard = Struct.new(:pos, :dir)

guard = nil
obstacles = Set.new
lines = $stdin.readlines
height = lines.length
width = lines[0].chomp.length
lines.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |c, x|
    if c == '#'
      obstacles << Coord[x, y]
    elsif c != '.'
      guard = Guard.new(Coord[x, y], Coord[0, -1])
    end
  end
end

visited = Set.new
while guard.pos.x >= 0 && guard.pos.x < width && guard.pos.y >= 0 && guard.pos.y < height
  new_pos = guard.pos + guard.dir
  
  if obstacles.include?(new_pos)
    guard.dir = guard.dir.rotate_clockwise
  else
    guard.pos = new_pos
  end

  visited << guard.pos
end

puts visited.size