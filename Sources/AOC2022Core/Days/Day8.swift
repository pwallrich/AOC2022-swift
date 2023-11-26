//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 08.12.22.
//

import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int

    func offset(by other: Point) -> Point {
        self + other
    }
}

func +(lhs: Point, rhs: Point) -> Point {
    Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs: Point, rhs: Point) -> Point {
    Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x):\(y))"
    }
}

class Day8: Day {
    var day: Int { 8 }
    let input: [Point: Int]
    let rowCount: Int
    let rowLength: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "30373\n25512\n65332\n33549\n35390"
        } else {
            inputString = try InputGetter.getInput(for: 8, part: .first)
        }
        var grid: [Point: Int] = [:]

        let splitBy = inputString
            .components(separatedBy: "\n")

        for (y, row) in splitBy.enumerated() {
            for (x, value) in row.enumerated() {
                let point = Point(x: x, y: y)
                guard let intValue = value.wholeNumberValue else {
                    fatalError("invalid input")
                }
                grid[point] = intValue
            }
        }

        self.input = grid
        rowCount = splitBy.count

        guard let firstIdx = inputString.firstIndex(where: { $0.isWhitespace }) else {
            throw DayError.invalidInput
        }
        rowLength = inputString.distance(from: inputString.startIndex, to: firstIdx)
    }

    func runPart1() throws {

        var count = rowLength * 2 + (rowCount - 2) * 2
        for y in 1..<(rowCount - 1) {
            for x in 1..<(rowLength - 1) {
                let curr = input[Point(x: x, y: y)]!
                if isVisibleTop(point: Point(x: x, y: y)) {
                    count += 1
                } else if isVisibleLeft(point: Point(x: x, y: y)) {
                    count += 1
                } else if isVisibleRight(point: Point(x: x, y: y)) {
                    count += 1
                } else if isVisibleBottom(point: Point(x: x, y: y)) {
                    count += 1
                }
            }
        }

        print(count)
    }

    func runPart2() throws {

        var maxScore = 0

        for (point, _) in input {
            if point.x == 0 || point.y == 0 || point.x == rowLength - 1 || point.y == rowCount - 1 {
                continue
            }
            let score = scoreTop(point: point) * scoreLeft(point: point) * scoreRight(point: point) * scoreBottom(point: point)

            maxScore = max(maxScore, score)
        }
        print(maxScore)
    }

    func isVisibleTop(point: Point) -> Bool {
        print("checking from top")
        for offset in 1...point.y {
            let curr = input[point]!
            let toCompare = input[Point(x: point.x, y: point.y - offset)]!
            print("checking point: \(point.x), \(point.y - offset), \(toCompare)")
            if curr <= toCompare {
                print("\(point.x), \(point.y), \(curr): can't be seen from top")
                return false
            }
        }
        print("seen from top \(point)")
        return true
    }

    func isVisibleBottom(point: Point) -> Bool {
        print("checking from bottom")
        for offset in (point.y+1)..<rowCount {
            let curr = input[point]!
            let toCompare = input[Point(x: point.x, y: offset)]!
            print("checking point: \(point.x), \(offset), \(toCompare)")
            if curr <= toCompare {
                print("\(point.x), \(point.y), \(curr): can't be seen from bottom")
                return false
            }
        }
        print("seen from bottom \(point)")
        return true
    }

    func isVisibleLeft(point: Point) -> Bool {
        for offset in 1...point.x {
            let curr = input[point]!
            let toCompare = input[Point(x: point.x - offset, y: point.y)]!
            print("checking point: \(point.x - offset), \(point.y), \(toCompare)")
            if curr <= toCompare {
                print("\(point.x), \(point.y), \(curr): can't be seen from left")
                return false
            }
        }
        print("seen from left \(point)")
        return true
    }

    func isVisibleRight(point: Point) -> Bool {
        for offset in (point.x+1)..<rowLength {
            let curr = input[point]!
            let toCompare = input[Point(x: offset, y: point.y)]!
            print("checking point: \(offset), \(point.y), \(toCompare)")
            if curr <= toCompare {
                print("\(point.x), \(point.y), \(curr): can't be seen from right")
                return false
            }
        }
        print("seen from right \(point)")
        return true
    }

    func scoreTop(point: Point) -> Int {
        var score = 1
        for offset in 1...point.y {
            if input[Point(x: point.x, y: point.y - offset)]! >= input[point]! {
                return score
            }
            score += 1
        }
        return score - 1
    }

    func scoreBottom(point: Point) -> Int {
        var score = 1
        for offset in (point.y+1)..<rowCount {
            if input[Point(x: point.x, y: offset)]! >= input[point]! {
                return score
            }
            score += 1
        }
        return score - 1
    }

    func scoreLeft(point: Point) -> Int {
        var score = 1
        for offset in 1...point.x {
            if input[Point(x: point.x - offset, y: point.y)]! >= input[point]! {
                return score
            }
            score += 1
        }

        return score - 1
    }

    func scoreRight(point: Point) -> Int {
        var score = 1
        for offset in (point.x+1)..<rowLength {
            if input[Point(x: offset, y: point.y)]! >= input[point]! {
                return score
            }
            score += 1
        }
        return score - 1
    }
}
