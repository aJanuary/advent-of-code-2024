#!/usr/bin/env ruby

require 'set'

graph = $stdin.readlines.flat_map do |line|
  src, dest = line.chomp.split('-')
  [[src, dest], [dest, src]]
end.group_by(&:first).transform_values {|l| l.map(&:last)}.to_h

clusters = graph.keys.map do |root|
  cluster = Set.new
  to_visit = [root]
  until to_visit.empty?
    node = to_visit.shift
    graph[node].each do |neighbor|
      if cluster.all? {|n| graph[n].include?(neighbor)}
        cluster << neighbor
        to_visit << neighbor
      end
    end
  end
  cluster
end

largest_cluster = clusters.max_by(&:size)
puts largest_cluster.sort.join(',')