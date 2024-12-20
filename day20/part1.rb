#!/usr/bin/env ruby

require '../lib/2d'

class PriorityQueue
  def initialize
    @queue = []
  end

  def push(item, priority)
    @queue << [item, priority]
    @queue.sort_by! {|_, p| p}
  end

  def pop
    @queue.shift
  end
end

start_pos = nil
end_pos = nil
map = Grid2D.new($stdin.readlines.each_with_index.map do |l, y|
  l.chomp.chars.each_with_index.map do |c, x|
    start_pos = Coord[x, y] if c == 'S'
    end_pos = Coord[x, y] if c == 'E'
    ['S', 'E', '.'].include?(c) ? :empty : :wall
  end
end)

distances = map.each_coord.map do |pos|
  [pos, Float::INFINITY]
end.to_h
distances[start_pos] = 0

queue = PriorityQueue.new
queue.push(start_pos, 0)

loop do
  c, cur_dist = queue.pop
  return nil if c.nil?
  break if c == end_pos

  Coord.cardinal_dirs.each do |dir|
    neighbor = c + dir
    next unless map.in_bounds?(neighbor)
    next if map[neighbor] == :wall

    if distances[neighbor] > distances[c] + 1
      distances[neighbor] = distances[c] + 1
      queue.push(neighbor, distances[neighbor])
    end
  end
end

viable_cheats = []
(1...map.height-1).each do |y|
  (1...map.width-1).each do |x|
    pos = Coord[x, y]
    next if map[pos] == :wall
    Coord.cardinal_dirs.each do |dir|
      hop_pos = pos + dir + dir
      if map.in_bounds?(hop_pos) && map[hop_pos] == :empty
        savings = distances[hop_pos] - distances[pos] - 2
        viable_cheats << pos if savings >= 100
      end
    end
  end
end

puts viable_cheats.size