//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 09.12.22.
//

import Foundation

class Day9: Day {
    var day: Int { 9 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
//            inputString = "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2"
            inputString = "R 5\nU 8\nL 8\nD 3\nR 17\nD 10\nL 25\nU 20"
        } else {
            inputString = try InputGetter.getInput(for: 9, part: .first)
        }

        self.input = inputString
            .components(separatedBy: "\n")
    }

    func runPart1() throws {
        var h = Point(x: 0, y: 0)
        var t = Point(x: 0, y: 0)
        var seenTs: Set<Point> = [t]
        for row in input where !row.isEmpty {
            let command = row.split(separator: " ")
            guard let direction = command.first?.first,
                  let amountString = command.last,
                  let amount = Int(String(amountString)) else {
                print("couldn't parse input row \(row)")
                continue
            }
            print("moving \(direction) \(amount)")
            for i in 0..<amount {
                switch direction {
                case "U":
                    h.y += 1
                case "D":
                    h.y -= 1
                case "R":
                    h.x += 1
                case "L":
                    h.x -= 1
                default:
                    print("command \(direction) not found")
                }
                guard !(h.y == t.y && h.x == t.x + 1 ||
                        h.y == t.y && h.x == t.x - 1 ||
                        h.y + 1 == t.y && h.x == t.x ||
                        h.y - 1 == t.y && h.x == t.x ||
                        h.y + 1 == t.y && h.x == t.x + 1 ||
                        h.y + 1 == t.y && h.x == t.x - 1 ||
                        h.y - 1 == t.y && h.x == t.x + 1 ||
                        h.y - 1 == t.y && h.x == t.x - 1 ||
                        h == t)
                else {
//                    print("skipping", h, t)
                    continue
                }
                if h.y == t.y {
                    let value = h.x - t.x
                    t.x += value / abs(value)
                } else if h.x == t.x {
                    let value = h.y - t.y
                    t.y += value / abs(value)
                } else {
                    let xValue = h.x - t.x
                    let yValue = h.y - t.y
                    t.x += xValue / abs(xValue)
                    t.y += yValue / abs(yValue)
                }
//                print(h, t)
                seenTs.insert(t)
            }
        }
        print(seenTs.count)
    }

    func runPart2() throws {
        var points = Array(repeating: Point(x: 0, y: 0), count: 10)

        var seenTs: Set<Point> = [Point(x: 0, y: 0)]
        for row in input where !row.isEmpty {
            let command = row.split(separator: " ")
            guard let direction = command.first?.first,
                  let amountString = command.last,
                  let amount = Int(String(amountString)) else {
                print("couldn't parse input row \(row)")
                continue
            }
            print("moving \(direction) \(amount)")
            for i in 0..<amount {
                switch direction {
                case "U":
                    points[0].y += 1
                case "D":
                    points[0].y -= 1
                case "R":
                    points[0].x += 1
                case "L":
                    points[0].x -= 1
                default:
                    print("command \(direction) not found")
                }
                for i in points.indices.dropFirst() {
                    points[i].follow(other: points[points.index(before: i)])
                }

//                print(h, t)
                seenTs.insert(points[9])
            }
        }
        print(seenTs.count)
    }
}

private extension Point {
    mutating func follow(other: Point) {
        guard !(other.y == y && other.x == x + 1 ||
                other.y == y && other.x == x - 1 ||
                other.y + 1 == y && other.x == x ||
                other.y - 1 == y && other.x == x ||
                other.y + 1 == y && other.x == x + 1 ||
                other.y + 1 == y && other.x == x - 1 ||
                other.y - 1 == y && other.x == x + 1 ||
                other.y - 1 == y && other.x == x - 1 ||
                other == self)
        else {
//                    print("skipping", h, t)
            return
        }
        if other.y == y {
            let value = other.x - x
            x += value / abs(value)
        } else if other.x == x {
            let value = other.y - y
            y += value / abs(value)
        } else {
            let xValue = other.x - x
            let yValue = other.y - y
            x += xValue / abs(xValue)
            y += yValue / abs(yValue)
        }
    }
}
