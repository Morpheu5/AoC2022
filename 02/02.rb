#!/usr/bin/env ruby

symbols = { A: "Rock", B: "Paper", C: "Scissors", X: "Rock", Y: "Paper", Z: "Scissors" }
draws = [ "Rock", "Paper", "Scissors" ]
games = File.readlines("input.txt").map { |game| game.split(' ').map { |l| l.to_sym } }

scores = games.map do |game|
    mine = (draws.index(symbols[game[1]]) + 1)
    if symbols[game[0]] == symbols[game[1]]
        3 + mine
    elsif (draws.index(symbols[game[1]]) - 1) % 3 == draws.index(symbols[game[0]])
        6 + mine
    else
        0 + mine
    end
end

puts "The first score is #{scores.reduce(:+)} but that's not how the game is played!"

scores = games.map do |game|
    if game[1] == :Y
        3 + (draws.index(symbols[game[0]]) + 1)
    elsif game[1] == :Z
        6 + 1 + ((draws.index(symbols[game[0]]) + 1) % 3)
    else
        0 + 1 + ((draws.index(symbols[game[0]]) - 1) % 3)
    end
end

puts "The actual score is #{scores.reduce(:+)}."