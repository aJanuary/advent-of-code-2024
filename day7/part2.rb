#!/usr/bin/env ruby

def is_valid(calibration)
  def _is_valid(answer, nums, total)
    return answer == total if nums.empty?
    return false if total > answer

    n, *rest = nums

    return true if _is_valid(answer, rest, total + n)
    return true if _is_valid(answer, rest, total * n)

    mag = Math.log10(n).to_i + 1
    concat = ((10**mag) * total) + n
    return true if _is_valid(answer, rest, concat)

    false
  end

  n, *rest = calibration[:nums]
  _is_valid(calibration[:answer], rest, n)
end

calibrations = $stdin.each_line.map do |line|
  answer, *nums = line.scan(/\d+/).map(&:to_i)
  { answer: answer, nums: nums }
end

valid_calibrations = calibrations.filter do |calibration|
  is_valid(calibration)
end

puts valid_calibrations.map {|c| c[:answer]}.sum