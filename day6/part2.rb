#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
end

Guard = Struct.new(:pos, :dir)

def adding_obstacle_causes_loop?(obstacle_pos, width, height, obstacles, guard)
  visited = Set.new
  guard_pos = Coord.new(guard.pos.x, guard.pos.y)
  guard_dir = Coord.new(guard.dir.x, guard.dir.y)

  while guard_pos.x >= 0 && guard_pos.x < width && guard_pos.y >= 0 && guard_pos.y < height
    new_pos = guard_pos + guard_dir
    
    if new_pos == obstacle_pos || obstacles.include?(new_pos)
      guard_dir = Coord.new(-guard_dir.y, guard_dir.x)
      return true unless visited.add?(Guard.new(guard_pos, guard_dir))
    else
      guard_pos = new_pos
    end
  end
  false
end

def get_visited_positions(width, height, obstacles, guard)
  visited = Set.new
  guard_pos = Coord.new(guard.pos.x, guard.pos.y)
  guard_dir = Coord.new(guard.dir.x, guard.dir.y)
  while guard_pos.x >= 0 && guard_pos.x < width && guard_pos.y >= 0 && guard_pos.y < height
    new_pos = guard_pos + guard_dir
    
    if obstacles.include?(new_pos)
      guard_dir = Coord.new(-guard_dir.y, guard_dir.x)
    else
      guard_pos = new_pos
    end

    visited << guard_pos
  end
  visited
end

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

visited = get_visited_positions(width, height, obstacles, guard)
num_successes = visited.count do |obstacle_pos|
  next if obstacle_pos.x == guard.pos.x && obstacle_pos.y == guard.pos.y
  adding_obstacle_causes_loop?(obstacle_pos, width, height, obstacles, guard)
end

puts num_successes