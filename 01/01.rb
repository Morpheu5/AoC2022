#!/usr/bin/env ruby

lines = File.readlines('input.txt')
sums = lines.join.split(/\n\n/).map { |elf| elf.split(/\n/).map(&:to_i).reduce(:+) }
puts "The elf carrying the most calories is carrying #{sums.max} calories."
puts "The top three elves are carrying #{sums.sort.last(3).sum} calories in total."