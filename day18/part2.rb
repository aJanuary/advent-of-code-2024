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

def is_completable?(grid, start, goal)
  distances = grid.each_coord.map do |pos|
    [pos, Float::INFINITY]
  end.to_h
  distances[start] = 0
  
  queue = PriorityQueue.new
  queue.push(start, 0)
  
  loop do
    c, cur_dist = queue.pop
    return true if c == goal
    return false if c.nil?
  
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
end

width, height = ARGV.map(&:to_i)

byte_positions = $stdin.readlines.map do |line|
  x, y = line.chomp.split(',').map(&:to_i)
  Coord[x, y]
end

start = Coord[0, 0]
goal = Coord[width - 1, height - 1]

window_start = 0
window_end = byte_positions.size

until window_end - window_start <= 1
  grid = Grid2D.new((0...height).map {|y| (0...width).map {|y| '.'}})
  mid_point = window_start + ((window_end - window_start) / 2)
  byte_positions.take(mid_point).each {|pos| grid[pos] = '#'}
  if is_completable?(grid, start, goal)
    window_start = mid_point
  else
    window_end = mid_point
  end
end

puts byte_positions[window_start]