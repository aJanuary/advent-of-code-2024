#!/usr/bin/env ruby

require 'set'

graph = $stdin.readlines.flat_map do |line|
  src, dest = line.chomp.split('-')
  [[src, dest], [dest, src]]
end.group_by(&:first).transform_values {|l| l.map(&:last)}.to_h

t_nodes = graph.keys.select {|k| k.start_with?('t')}
clusters = t_nodes.flat_map do |t_node|
  graph[t_node].combination(2).select do |a, b|
    graph[a].include?(b)
  end.map {|a, b| Set.new([a, b, t_node])}
end.uniq
puts clusters.inspect
puts clusters.size