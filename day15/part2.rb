#!/usr/bin/env ruby

require 'set'
require '../lib/2d'

def is_box?(x)
  x == :box_left || x == :box_right
end

map_src, instructions_src = $stdin.read.split("\n\n")

robot = nil
map = Grid2D.new(map_src.split("\n").each_with_index.map do |line, y|
  line.chomp.chars.each_with_index.flat_map do |cell, x|
    if cell == '#'
      [:wall, :wall]
    elsif cell == 'O'
      [:box_left, :box_right]
    elsif cell == '@'
      robot = Coord[x * 2, y]
      [:empty, :empty]
    else
      [:empty, :empty]
    end
  end
end)

instructions = instructions_src.split("\n").join.chars.map do |instruction|
  {
    '^' => Coord[0, -1],
    '>' => Coord[1, 0],
    'v' => Coord[0, 1],
    '<' => Coord[-1, 0]
  }[instruction]
end

instructions.each do |instruction|
  edges = [robot + instruction]
  boxes_to_push = []
  seen = Set.new
  can_move = true
  until edges.empty?
    cur = edges.shift
    if map[cur] == :wall
      can_move = false
      break
    elsif is_box?(map[cur]) && seen.add?(cur)
      boxes_to_push.unshift(cur)
      other_half = cur + Coord[map[cur] == :box_left ? 1 : -1, 0]
      edges << other_half
      edges << cur + instruction
    end
  end

  if can_move
    boxes_to_push.each do |box|
      map[box + instruction] = map[box]
      map[box] = :empty
    end
    robot += instruction
  end
end

gps_coords = map.each_coord.filter_map do |pos|
  if map[pos] == :box_left
    (100 * pos.y) + pos.x
  end
end

puts gps_coords.sum