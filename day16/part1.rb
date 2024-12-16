#!/usr/bin/env ruby

require 'set'
require '../lib/2d'

PosAndDir = Struct.new(:coord, :dir)

def find_fastest_path(graph, start_node, end_node)
  distances = graph.keys.map do |node|
    [node, Float::INFINITY]
  end.to_h
  distances[start_node] = 0

  unvisited = Set.new(distances.keys)

  loop do
    c = unvisited.min_by {|node| distances[node]}
    return distances[end_node] if c == end_node
    unvisited.delete(c) unless c.nil?

    graph[c].each do |neighbor, step_cost|
      if unvisited.include?(neighbor)
        distances[neighbor] = [distances[neighbor], distances[c] + step_cost].min
      end
    end
  end
end

start_coord = nil
end_coord = nil
empty_coords = Set.new($stdin.each_line.each_with_index.flat_map do |line, y|
  line.chomp.each_char.each_with_index.filter_map do |char, x|
    start_coord = Coord[x, y] if char == 'S'
    end_coord = Coord[x, y] if char == 'E'
    Coord[x, y] if char != '#'
  end
end)

graph = Hash.new {|h, k| h[k] = []}
fringe = [PosAndDir.new(start_coord, Coord[1, 0])]
visited = Set.new
until fringe.empty?
  cur = fringe.shift
  next unless visited.add?(cur)

  edges = [
    [PosAndDir.new(cur.coord, cur.dir.rotate_clockwise), 1000],
    [PosAndDir.new(cur.coord, cur.dir.rotate_anticlockwise), 1000]
  ]

  probe = cur.coord + cur.dir
  if empty_coords.include?(probe)
    length = 1
    while empty_coords.include?(probe) && !empty_coords.include?(probe + cur.dir.rotate_clockwise) && !empty_coords.include?(probe + cur.dir.rotate_anticlockwise)
      break unless empty_coords.include?(probe + cur.dir)
      probe += cur.dir
      length += 1
    end
    edges << [PosAndDir.new(probe, cur.dir), length]
  end
  edges.each do |target, length|
    graph[cur] << [target, length]
    fringe << target
  end
end

graph.filter {|k, v| k.coord == end_coord}.each do |k, v|
  v << [:end, 0]
end
graph[:end] = []

puts find_fastest_path(graph, PosAndDir.new(start_coord, Coord[1, 0]), :end)