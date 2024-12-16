#!/usr/bin/env ruby

require 'set'
require '../lib/2d'

PosAndDir = Struct.new(:coord, :dir)

def find_best_seats(graph, start_node, end_node)
  distances = graph.keys.map do |node|
    [node, Float::INFINITY]
  end.to_h
  distances[start_node] = 0

  prev = Hash.new {|h, k| h[k] = []}

  unvisited = Set.new(distances.keys)

  loop do
    c = unvisited.min_by {|node| distances[node]}

    if c == end_node
      seats = Set.new
      visited_nodes = Set.new
      queue = [end_node]
      until queue.empty?
        cur = queue.shift
        visited_nodes << cur
        prev[cur].each do |p|
          xs = [p.coord.x, cur.coord.x]
          ys = [p.coord.y, cur.coord.y]
          (ys.min..ys.max).each do |y|
            (xs.min..xs.max).each do |x|
              seats << Coord[x, y]
            end
          end
          queue << p
        end
      end
      return seats
    end

    unvisited.delete(c) unless c.nil?

    graph[c].each do |neighbor, step_cost|
      if unvisited.include?(neighbor)
        if distances[neighbor] > distances[c] + step_cost
          distances[neighbor] = distances[c] + step_cost
          prev[neighbor] = [c]
        elsif distances[neighbor] == distances[c] + step_cost
          prev[neighbor] << c
        end
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

end_node = PosAndDir.new(end_coord, Coord[0, 0])
graph.filter {|k, v| k.coord == end_coord}.each do |k, v|
  v << [end_node, 0]
end
graph[end_node] = []

best_seats = find_best_seats(graph, PosAndDir.new(start_coord, Coord[1, 0]), end_node)
puts best_seats.count