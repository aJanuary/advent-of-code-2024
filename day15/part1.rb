#!/usr/bin/env ruby

require '../lib/2d'

map_src, instructions_src = $stdin.read.split("\n\n")

robot = nil
map = Grid2D.new(map_src.split("\n").each_with_index.map do |line, y|
  line.chomp.chars.each_with_index.map do |cell, x|
    if cell == '#'
      :wall
    elsif cell == 'O'
      :box
    elsif cell == '@'
      robot = Coord[x, y]
      :empty
    else
      :empty
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
  cur = robot + instruction
  boxes_to_push = []
  while map[cur] == :box
    boxes_to_push << cur
    cur += instruction
  end
  if map[cur] == :empty
    boxes_to_push.each do |box|
      map[box + instruction] = :box
    end
    robot += instruction
    map[robot] = :empty
  end
end

gps_coords = map.each_coord.filter_map do |pos|
  if map[pos] == :box
    (100 * pos.y) + pos.x
  end
end

puts gps_coords.sum