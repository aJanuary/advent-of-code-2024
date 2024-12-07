#!/usr/bin/env ruby

calibrations = $stdin.each_line.map do |line|
  answer, *nums = line.scan(/\d+/).map(&:to_i)
  { answer: answer, nums: nums }
end

valid_calibrations = calibrations.filter do |calibration|
  potential_answers = calibration[:nums].reduce([]) do |a, b|
    if a == []
      [b]
    else
      a.flat_map {|n| [n + b, n * b, "#{n}#{b}".to_i]}
    end
  end
  potential_answers.include?(calibration[:answer])
end

puts valid_calibrations.map {|c| c[:answer]}.sum