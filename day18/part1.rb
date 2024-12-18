#!/usr/bin/env ruby

require '../lib/2d'
require 'set'

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

width, height, num_to_drop = ARGV.map(&:to_i)

byte_positions = $stdin.readlines.map do |line|
  x, y = line.chomp.split(',').map(&:to_i)
  Coord[x, y]
end

grid = Grid2D.new((0...height).map {|y| (0...width).map {|y| '.'}})
byte_positions.take(num_to_drop).each {|pos| grid[pos] = '#'}

start = Coord[0, 0]
goal = Coord[width - 1, height - 1]

distances = grid.each_coord.map do |pos|
  [pos, Float::INFINITY]
end.to_h
distances[start] = 0

queue = PriorityQueue.new
queue.push(start, 0)

loop do
  c, cur_dist = queue.pop
  break if c == goal

  Coord.cardinal_dirs.each do |dir|
    neighbor = c + dir
    next unless grid.in_bounds?(neighbor)
    next if grid[neighbor] == '#'

    if distances[neighbor] > distances[c] + 1
      distances[neighbor] = distances[c] + 1
      queue.push(neighbor, distances[neighbor])
    end
  end
end

puts distances[goal]