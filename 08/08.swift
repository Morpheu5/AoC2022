#!/usr/bin/env swift

import Foundation

struct Matrix<🤌> {
    let rows: Int, cols: Int
    private var cells: [🤌?]

    init(repeating repeatedValue: 🤌?, rows: Int, cols: Int) {
        assert(rows > 0 && cols > 0)
        self.rows = rows; self.cols = cols
        cells = Array(repeatElement(repeatedValue, count: rows * cols))
    }

    subscript(_ ridx: Int, _ cidx: Int) -> 🤌? {
        get { cells[(ridx * cols) + cidx] }
        set { cells[(ridx * cols) + cidx] = newValue }
    }
}

func isTreeVisibleAt(row: Int, col: Int, in mat: Matrix<Int>) -> Bool {
    let treeHeight = mat[row, col]!
    let leftCols = 0..<col, rightCols = col+1..<mat.cols
    let topRows = 0..<row, bottomRows = row+1..<mat.rows
    return leftCols.allSatisfy { mat[row, $0]! < treeHeight } ||
           rightCols.allSatisfy { mat[row, $0]! < treeHeight } ||
           topRows.allSatisfy { mat[$0, col]! < treeHeight } ||
           bottomRows.allSatisfy { mat[$0, col]! < treeHeight }
}

func countVisibleTrees(in mat: Matrix<Int>) -> Int {
    // This would be a bit neater with the product(_:_:) function from Algorithms
    var count = 0
    for c in 0...mat.cols-1 {
        for r in 0...mat.rows-1 {
            if isTreeVisibleAt(row: r, col: c, in: mat) { count += 1 }
        }
    }
    return count
}

func countVisibleTreesFrom(row: Int, col: Int, alongCols cols: [Int], in mat: Matrix<Int>) -> Int {
    let treeHeight = mat[row, col]!
    var count = 0
    for c in cols {
        // TODO Simplify break condition
        if mat[row, c]! < treeHeight { count += 1 }
        else { count += 1; break }
    }
    return count
}

func countVisibleTreesFrom(row: Int, col: Int, alongRows rows: [Int], in mat: Matrix<Int>) -> Int {
    let treeHeight = mat[row, col]!
    var count = 0
    for r in rows {
        // TODO Simplify break condition
        if mat[r, col]! < treeHeight { count += 1 }
        else { count += 1; break }
    }
    return count
}

func scenicScoreForTreeAt(row: Int, col: Int, in mat: Matrix<Int>) -> Int {
    return [
        countVisibleTreesFrom(row: row, col: col, alongCols: Array((0..<col).reversed()), in: mat),
        countVisibleTreesFrom(row: row, col: col, alongCols: Array((col+1)..<mat.cols), in: mat),
        countVisibleTreesFrom(row: row, col: col, alongRows: Array((0..<row).reversed()), in: mat),
        countVisibleTreesFrom(row: row, col: col, alongRows: Array((row+1)..<mat.rows), in: mat),
    ].reduce(1, *)
}

func highestScenicScoreIn(_ mat: Matrix<Int>) -> Int {
    var scores: [Int] = []
    for row in 0..<field.rows {
        for col in 0..<field.cols {
            scores.append(scenicScoreForTreeAt(row: row, col: col, in: mat))
        }
    }
    return scores.max()!
}

let input = try! String(contentsOfFile: "input.txt").split(separator: "\n").map { String($0) }
let rows = input.count, cols = input[0].count
var field = Matrix<Int>(repeating: 0, rows: rows, cols: cols)
for (row, string) in input.enumerated() {
    for (col, character) in string.enumerated() {
        // Why don't you like strings, Swift. Whyyyy?!
        field[row, col] = Int(String(character))
    }
}

print("The number of visible trees is \(countVisibleTrees(in: field))")
print("The tree with the highest scenic score has a scenic score of \(highestScenicScoreIn(field))")
