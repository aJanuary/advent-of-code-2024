#!/usr/bin/env ruby

Coord = Struct.new(:x, :y)
Robot = Struct.new(:pos, :vel)

src_lines = $stdin.readlines
width, height = src_lines[0].scan(/\d+/).map(&:to_i)
robots = src_lines[1..-1].map do |line|
  px, py, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  Robot.new(Coord.new(px, py), Coord.new(vx, vy))
end

pos_after_100_secs = robots.map do |robot|
  final_x = (robot.pos.x + (100 * robot.vel.x)) % width
  final_y = (robot.pos.y + (100 * robot.vel.y)) % height
  Coord.new(final_x, final_y)
end

centre_x = width / 2
centre_y = height / 2

quadrants = pos_after_100_secs.filter_map do |pos|
  if pos.x < centre_x && pos.y < centre_y
    0
  elsif pos.x > centre_x && pos.y < centre_y
    1
  elsif pos.x > centre_x && pos.y > centre_y
    2
  elsif pos.x < centre_x && pos.y > centre_y
    3
  end
end

quadrant_counts = quadrants.group_by(&:itself).values.map(&:size)
puts quadrant_counts.inject(&:*)