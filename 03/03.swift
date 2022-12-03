#!/usr/bin/env swift

import Foundation

func process(line: String.SubSequence) -> Int {
    Set(line.prefix(line.count/2)).intersection(Set(line.suffix(line.count/2))).map({ priorities[$0]! }).reduce(0, +)
}

func process(group: Array<Set<Character>>) -> Int {
    group.reduce(group[0], { $0.intersection($1) }).map({ priorities[$0]! }).reduce(0, +)
}

let priorities = Dictionary(uniqueKeysWithValues: zip(Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 1...52))
let lines = try String(contentsOfFile: "input.txt").split(separator: "\n")

let linesPriorities = lines.map(process)
print(String(format: "The sum of the priorities of the wrong items is %d.", linesPriorities.reduce(0, +)))

let groups = stride(from: 0, to: lines.count, by: 3).map { Array(lines[$0...$0+2]).map {Set($0)} }
let groupsPriorities = groups.map(process)
print(String(format: "The sum of the priorities of the badges is %d.", groupsPriorities.reduce(0, +)))