#!/usr/bin/env swift

import Foundation

func rangeSpecToRange(_ s: String) -> ClosedRange<Int> {
    let bounds = s.split(separator: "-").map { Int($0)! }
    return bounds[0]...bounds[1]
}

let ranges = try String(contentsOfFile: "input.txt").split(separator: "\n")
             .map { String($0).split(separator: ",").map { rangeSpecToRange(String($0)) } }

let fullyContainedRanges = ranges.filter { $0[0].contains($0[1]) || $0[1].contains($0[0]) }
print(String(format: "There are %d fully contained ranges.", fullyContainedRanges.count))

let overlappingRanges = ranges.filter { $0[0].overlaps($0[1]) }
print(String(format: "There are %d overlapping ranges.", overlappingRanges.count))