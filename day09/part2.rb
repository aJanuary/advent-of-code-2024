#!/usr/bin/env ruby

def compact(disc)
  i = disc.size - 1
  while i >= 0
    if !disc[i][:can_move]
      i -= 1
    else
      disc_to_move = disc[i]

      new_index = disc.index {|c| c[:type] == :free && c[:size] >= disc_to_move[:size]}
      if new_index.nil? || new_index >= i
        i -= 1
      else
        disc_to_move[:can_move] = false
        disc[new_index][:size] -= disc_to_move[:size]
        disc[i] = { type: :free, size: disc_to_move[:size], can_move: false }
        disc.insert(new_index, disc_to_move)
      end
    end
  end
end

def checksum(disc)
  blocks = disc.flat_map do |c|
    if c[:type] == :free
      [0] * c[:size]
    else
      [c[:id]] * c[:size]
    end
  end
  blocks.each_with_index.map do |file_id, index|
    file_id * index
  end.sum
end

disc = $stdin.read.chomp.chars.each_slice(2).each_with_index.flat_map do |(file_size, free_size), index|
  chunk = [{ type: :file, id: index, size: file_size.to_i, can_move: true }]
  chunk << { type: :free, size: free_size.to_i, can_move: false } if free_size.to_i != 0
  chunk
end

compact(disc)
puts checksum(disc)