#!/usr/bin/env ruby

Coord = Struct.new(:x, :y) do
  def to_s
    "(#{x},#{y})"
  end

  def inspect
    to_s
  end

  def +(other)
    Coord.new(x + other.x, y + other.y)
  end
end

Map = Struct.new(:map) do
  def [](coord)
    map[coord.y][coord.x]
  end

  def []=(coord, value)
    map[coord.y][coord.x] = value
  end

  def width
    map[0].size
  end

  def height
    map.size
  end

  def each_pos(&block)
    return enum_for(:each_pos) unless block_given?

    height.times do |y|
      width.times do |x|
        yield Coord.new(x, y)
      end
    end
  end
end

def debug(map, robot)
  (0...map.height).each do |y|
    (0...map.width).each do |x|
      if x == robot.x && y == robot.y
        print('@')
      else
        print({
          wall: '#',
          box: 'O',
          empty: '.'
        }[map[Coord.new(x, y)]])
      end
    end
    print("\n")
  end
end

map_src, instructions_src = $stdin.read.split("\n\n")

robot = nil
map = Map.new(map_src.split("\n").each_with_index.map do |line, y|
  line.chomp.chars.each_with_index.map do |cell, x|
    if cell == '#'
      :wall
    elsif cell == 'O'
      :box
    elsif cell == '@'
      robot = Coord.new(x, y)
      :empty
    else
      :empty
    end
  end
end)

instructions = instructions_src.split("\n").join.chars.map do |instruction|
  {
    '^' => Coord.new(0, -1),
    '>' => Coord.new(1, 0),
    'v' => Coord.new(0, 1),
    '<' => Coord.new(-1, 0)
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

gps_coords = map.each_pos.filter_map do |pos|
  if map[pos] == :box
    (100 * pos.y) + pos.x
  end
end

puts gps_coords.sum