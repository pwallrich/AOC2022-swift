//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 12.12.22.
//

import Foundation

class Day12: Day {
    var day: Int { 12 }
    let input: [Point: Int]
    let start: Point
    let end: Point
    let width: Int
    let height: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "Sabqponm\nabcryxxl\naccszExk\nacctuvwj\nabdefghi"
        } else {
            inputString = try InputGetter.getInput(for: 12, part: .first)
        }
        var y = 0
        var x = 0
        var board: [Point: Int] = [:]
        var start: Point?
        var end: Point?
        for char in inputString {
            if char == "\n" {
                x = 0
                y += 1
                continue
            }
            guard char.isLetter else {
                fatalError("invalid input")
            }
            let point = Point(x: x, y: y)
            let value: UInt8
            switch char {
            case "S":
                start = point
                value = 0
            case "E":
                end = point
                value = 27
            case "a"..."z":
                value = char.asciiValue! - Character("a").asciiValue! + 1
            default:
                fatalError("invalid input")
            }
            board[point] = Int(value)
            x += 1
        }
        self.input = board
        self.start = start!
        self.end = end!
        self.width = x
        self.height = y + 1
    }

    func runPart1() throws {
        runAStar()
    }

    func runPart2() throws {
        runAStarReversed()
    }

    func runAStar() {
        let notSeen = input
        var found: [Point: [Point]] = [start: []]
        var nextMoves: [Point: (Int, [Point])] = [:]
        var curr = start
        while curr != end {
//            input.prettyPrint(width: width, height: height, highlightRed: [curr], highlightGreen: Set(found.keys))

//            print("starting step with \(curr)")
            for offsets in [(-1, 0), (0, -1), (1, 0), (0, 1)] {
                let point = Point(x: curr.x + offsets.0, y: curr.y + offsets.1)
                let currValue = input[curr]!
                guard found[point] == nil else {
                    continue
                }
                guard let value = notSeen[point],
                      value <= currValue + 1 else {
                    continue
                }

                let heuristic = point.manhattanTo(other: end) + found[curr]!.count
                if let oldValue = nextMoves[point] {
                    if oldValue.0 > heuristic {
                        nextMoves[point] = (heuristic, found[curr]! + [curr])
                    }
                } else {
                    nextMoves[point] = (heuristic, found[curr]! + [curr])
                }

            }
//            print("nextMoves \(nextMoves.map { $0.key})")
//            print("found \(found)")
//            print()
            guard let next = nextMoves.sorted(by: { $0.value.0 < $1.value.0 }).first else {
                fatalError("no next move found")
            }
            found[next.key] = next.value.1
            nextMoves[next.key] = nil
            curr = next.key
        }
        print(found[end])
        print(found[end]!.count)
    }

    func runAStarReversed() {
        var notSeen = input
        var found: [Point: [Point]] = [end: []]
        var nextMoves: [Point: (Int, [Point])] = [:]
        var curr = end
        var best: [Point]?
        while !notSeen.isEmpty {
            if notSeen[curr] == 1 {
                if found[curr]!.count < best?.count ?? .max {
                    best = found[curr]
                }
            }
            notSeen[curr] = nil

//            input.prettyPrint(width: width, height: height, highlightRed: [curr], highlightGreen: Set(found.keys))
//            print("starting step with \(curr)")
            for offsets in [(-1, 0), (0, -1), (1, 0), (0, 1)] {
                let point = Point(x: curr.x + offsets.0, y: curr.y + offsets.1)
                let currValue = input[curr]!
                guard found[point] == nil else {
                    continue
                }
                guard let value = notSeen[point],
                      value == currValue || value == currValue + 1 || value == currValue - 1 || value == currValue + 2 else {
                    continue
                }

                let heuristic = point.manhattanTo(other: start) + found[curr]!.count
                if let oldValue = nextMoves[point] {
                    if oldValue.0 > heuristic {
                        nextMoves[point] = (heuristic, found[curr]! + [curr])
                    }
                } else {
                    nextMoves[point] = (heuristic, found[curr]! + [curr])
                }

            }
//            print("nextMoves \(nextMoves.map { $0.key})")
//            print("found \(found)")
//            print()
            guard let next = nextMoves.sorted(by: { $0.value.0 < $1.value.0 }).first else {
                break
            }
            found[next.key] = next.value.1
            nextMoves[next.key] = nil
            curr = next.key

        }
        print(curr)
        print(best)
        print(best?.count)
    }
}

extension Point {
    func manhattanTo(other: Point) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }
}

extension Dictionary where Key == Point, Value == Int {
    func prettyPrint(width: Int, height: Int, highlightRed: Set<Point>, highlightGreen: Set<Point>) {
        var toPrint = ""
        let offset = Character("a").asciiValue! - 1
        for y in 0..<height {
            for x in 0..<width {
                let point = Point(x: x, y: y)
                let currAscii = self[point]!
                let char: Character
                switch currAscii {
                case 0: char = "S"
                case 27: char = "E"
                default:
                    char = Character(UnicodeScalar(UInt8(currAscii) + offset))
                }
                if highlightRed.contains(point) {
                    toPrint.append("\(Colors.red)\(char)\(Colors.white)")
                } else if highlightGreen.contains(point) {
                    toPrint.append("\(Colors.green)\(char)\(Colors.white)")
                } else {
                    toPrint.append(char)
                }
//                print(char, terminator: "")
            }
            toPrint.append("\n")
        }
        print(toPrint)
        print()
    }
}

struct Colors {
    static let reset = "\u{001B}[0;0m"
    static let black = "\u{001B}[0;30m"
    static let red = "\u{001B}[0;31m"
    static let green = "\u{001B}[0;32m"
    static let yellow = "\u{001B}[0;33m"
    static let blue = "\u{001B}[0;34m"
    static let magenta = "\u{001B}[0;35m"
    static let cyan = "\u{001B}[0;36m"
    static let white = "\u{001B}[0;37m"
}
