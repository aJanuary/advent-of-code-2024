#!/usr/bin/env ruby

def compact(disc)
  free_index = 0
  file_index = disc.size - 1
  while free_index <= file_index
    if disc[free_index] == :empty
      while disc[file_index] == :empty
        file_index -= 1
      end
      disc[free_index] = disc[file_index]
      disc[file_index] = :empty
    end
    free_index += 1
  end
end

def checksum(disc)
  disc.filter {|file_id| file_id != :empty}.each_with_index.map do |file_id, index|
    file_id * index
  end.sum
end

disc = $stdin.read.chomp.chars.each_slice(2).each_with_index.flat_map do |(file_size, free_size), index|
  ([index] * file_size.to_i) + ([:empty] * free_size.to_i)
end

compact(disc)
puts checksum(disc)