#!/usr/bin/env ruby

require 'chunky_png'
require 'set'

Coord = Struct.new(:x, :y)
Robot = Struct.new(:pos, :vel)

src_lines = $stdin.readlines
width, height = src_lines[0].scan(/\d+/).map(&:to_i)
robots = src_lines[1..-1].map do |line|
  px, py, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  Robot.new(Coord.new(px, py), Coord.new(vx, vy))
end

seen = Set.new

(1..).each do |i|
  robots = robots.map do |robot|
    new_x = (robot.pos.x + (1 * robot.vel.x)) % width
    new_y = (robot.pos.y + (1 * robot.vel.y)) % height
    Robot.new(Coord.new(new_x, new_y), robot.vel)
  end

  break if !seen.add?(robots)

  png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::BLACK)
  robots.each do |robot|
    png[robot.pos.x, robot.pos.y] = ChunkyPNG::Color.rgba(255, 255, 255, 255)
  end
  png.save("output/#{i}.png", :interlace => true)
  puts "Saved frame #{i}"
end