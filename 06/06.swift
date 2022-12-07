#!/usr/bin/env swift

import Foundation

enum FindMarker: Error {
    case markerNotFound
}

enum FindDuplicate: Error {
    case duplicateNotFound
}

func findFirstDuplicateIn(string: String) throws -> Int {
    let s = Array(string)
    for i in 0..<s.count {
        for j in (i+1)..<s.count {
            if s[i] == s[j] {
                return i
            }
        }
    }
    throw FindDuplicate.duplicateNotFound
}

func findMarkerInString(_ string: String, from: Int, length: Int) throws -> Int {
    var i = from
    let a = Array(string)
    while i < a.count {
        do {
            let j = try findFirstDuplicateIn(string:String(a[i..<i+length]))
            i += j + 1
        } catch FindDuplicate.duplicateNotFound {
            return i + length
        }
    }
    throw FindMarker.markerNotFound
}

let input = try! String(contentsOfFile: "input.txt")
let transmissionMarker = try findMarkerInString(input, from: 0, length: 4)
print("We need to process \(transmissionMarker) characters before the first valid transmission marker.")
let messageMarker = try findMarkerInString(input, from: transmissionMarker, length: 14)
print("We need to process \(messageMarker) characters before the first valid message marker.")