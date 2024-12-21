#!/usr/bin/env ruby

CACHE = {}
def find_paths(graph, start_node, end_node)
  if CACHE.key?([graph, start_node, end_node])
    return CACHE[[graph, start_node, end_node]]
  end

  paths = []
  queue = [[start_node, Set.new, []]]
  until queue.empty?
    node, visited, path = queue.shift
    if node == end_node
      if paths.empty? || path.length < paths.first.length
        paths = [path]
      elsif path.length == paths.first.length
        paths << path
      end
    else
      graph[node].each do |edge, neighbor|
        queue.push([neighbor, visited + [neighbor], path + [edge]]) unless visited.include?(neighbor)
      end
    end
  end

  CACHE[[graph, start_node, end_node]] = paths
  paths
end

numeric_keypad = {
  'A' => { '<' => '0', '^' => '3' },
  '0' => { '^' => '2', '>' => 'A' },
  '1' => { '>' => '2', '^' => '4' },
  '2' => { '^' => '5', '>' => '3', '<' => '1', 'v' => '0' },
  '3' => { '<' => '2', 'v' => 'A', '^' => '6' },
  '4' => { '^' => '7', '>' => '5', 'v' => '1' },
  '5' => { 'v' => '2', '>' => '6', '<' => '4', '^' => '8' },
  '6' => { '<' => '5', 'v' => '3', '^' => '9' },
  '7' => { 'v' => '4', '>' => '8' },
  '8' => { '<' => '7', 'v' => '5', '>' => '9' },
  '9' => { 'v' => '6', '<' => '8' }
}

directional_keypad = {
  '^' => { '>' => 'A', 'v' => 'v' },
  'A' => { 'v' => '>', '<' => '^' },
  '<' => { '>' => 'v' },
  'v' => { '^' => '^', '>' => '>', '<' => '<' },
  '>' => { '^' => 'A', '<' => 'v' },
}

codes = $stdin.readlines.map(&:chomp).map(&:chars)

complexities = codes.map do |code|
  numerical_pos = 'A'
  sequences = [[]]
  code.each do |button|
    numerical_dirs = find_paths(numeric_keypad, numerical_pos, button).map {|path| path + ['A']}
    sequences = sequences.flat_map do |prefix|
      numerical_dirs.map do |dirs|
        prefix + dirs
      end
    end
    numerical_pos = button
  end

  2.times do
    sequences = sequences.flat_map do |code|
      robot_pos = 'A'
      sequences = [[]]
      code.each do |button|
        dirs = find_paths(directional_keypad, robot_pos, button).map {|path| path + ['A']}
        sequences = sequences.flat_map do |prefix|
          dirs.map do |dirs|
            prefix + dirs
          end
        end
        robot_pos = button
      end
      sequences
    end
  end

  shortest_sequence_len = sequences.map(&:length).min
  numeric_part_of_code = code.select {|b| b.match?(/[[:digit:]]/)}.join.to_i
  shortest_sequence_len * numeric_part_of_code
end

puts complexities.sum
