#!/usr/bin/env ruby

def compact(disc)
  (0...disc.size).each do |index|
    if disc[index] == :empty
      (disc.size - 1).downto(0).each do |index2|
        if disc[index2] != :empty
          disc[index], disc[index2] = disc[index2], disc[index]
          break
        end
      end
    end
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