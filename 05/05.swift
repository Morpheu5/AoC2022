#!/usr/bin/env swift

import Foundation

typealias Instruction = (quantity: Int, from: Int, to: Int)
func parseInstruction(_ i: String) -> Instruction {
    let components = i.split(separator: " ")
    return Instruction(quantity: Int(components[1])!, from: Int(components[3])!-1, to: Int(components[5])!-1)
}

func doTheThing(round: Int) -> [[String]] {
    let text = try! String(contentsOfFile: "input.txt").split(separator: "\n")
    let findStackBottomsRegex = try! Regex("^(\\s+[0-9])+\\s+$")
    let stackBottomsIndex = text.firstIndex(where: { $0.matches(of: findStackBottomsRegex).count > 0 })!
    let stackBottoms = String(text[stackBottomsIndex])
    let stackCount = stackBottoms.split(separator: try! Regex("\\s")).count
    let stackText = Array(text[0..<stackBottomsIndex].reversed())
    let instructions = Array(text[stackBottomsIndex+1..<text.count])

    var stacks: [[String]] = []
    for _ in 0..<stackCount {
        stacks.append([])
    }
    let r = try! Regex("(\\s{4}+|\\[[A-Z]\\] ?)")
    for row in stackText {
        let matches = row.matches(of: r).map { String(String($0.0).prefix(2).suffix(1)) }
        for i in 0..<matches.count {
            if matches[i] != " " {
                stacks[i].append(matches[i])
            }
        }
    }
    if round == 1 {
        for instruction in instructions {
            let i = parseInstruction(String(instruction))
            for _ in 0..<i.quantity {
                stacks[i.to].append(stacks[i.from].removeLast())
            }
        }
    } else {
        for instruction in instructions {
            let i = parseInstruction(String(instruction))
            let from = stacks[i.from]
            let payload = from[from.count-i.quantity..<from.count]
            stacks[i.to].append(contentsOf: payload)
            stacks[i.from].removeLast(i.quantity)
        }
    }

    return stacks
}

print("The crates at the top of each stack should have been: \(doTheThing(round: 1).map { $0.last! }.joined(separator: ""))")
print("Instead they are: \(doTheThing(round: 2).map { $0.last! }.joined(separator: ""))")