//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 14.12.22.
//

import Foundation

class Day14: Day {
    var day: Int { 14 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "498,4 -> 498,6 -> 496,6\n503,4 -> 502,4 -> 502,9 -> 494,9"
        } else {
            inputString = try InputGetter.getInput(for: 14, part: .first)
        }

        self.input = inputString

    }

    func runPart1() throws {
        var (grid, maxX, minX, maxY, minY) = setupGrid()
//        grid.prettyPrint(xRange: (minX-5)...(maxX+5), yRange: 0...maxY)


        while true {
            var count = 0
            var sandKorn = Point(x: 500, y: 0)
            var didStop = false
            while sandKorn.y <= maxY {
//                print("evaluating sandkorn at \(sandKorn)")
                let offset: Point
                if grid[Point(x: sandKorn.x, y: sandKorn.y + 1)] == nil {
//                    print("can move down")
                    offset = Point(x: 0, y: 1)
                } else if grid[Point(x: sandKorn.x - 1, y: sandKorn.y + 1)] == nil {
//                    print("can move down left")
                    offset = Point(x: -1, y: 1)
                } else if grid[Point(x: sandKorn.x + 1, y: sandKorn.y + 1)] == nil {
//                    print("can move down right")
                    offset = Point(x: 1, y: 1)
                } else {
//                    print("can't move anywhere")
                    count += 1
                    didStop = true
                    grid[sandKorn] = -1
                    break
                }

                sandKorn.x += offset.x
                sandKorn.y += offset.y


//                print()
            }
            if !didStop {
                print("result: \(grid.values.filter { $0 == -1 }.count)")
                return
            }
        }
    }

    func runPart2() throws {
        var (grid, maxX, minX, maxY, minY) = setupGrid()
//        grid.prettyPrint(xRange: (minX-5)...(maxX+5), yRange: 0...maxY)

        let floor = maxY + 2
        while grid[Point(x: 500, y: 0)] == nil {
            var count = 0
            var sandKorn = Point(x: 500, y: 0)
            while sandKorn.y <= maxY {
//                print("evaluating sandkorn at \(sandKorn)")
                let offset: Point
                if grid[Point(x: sandKorn.x, y: sandKorn.y + 1)] == nil {
//                    print("can move down")
                    offset = Point(x: 0, y: 1)
                } else if grid[Point(x: sandKorn.x - 1, y: sandKorn.y + 1)] == nil {
//                    print("can move down left")
                    offset = Point(x: -1, y: 1)
                } else if grid[Point(x: sandKorn.x + 1, y: sandKorn.y + 1)] == nil {
//                    print("can move down right")
                    offset = Point(x: 1, y: 1)
                } else {
//                    print("can't move anywhere")
                    break
                }

                sandKorn.x += offset.x
                sandKorn.y += offset.y
//                print()
            }
//            print("inserting at \(sandKorn)")
            count += 1
            grid[sandKorn] = -1
//            if count == 50 {
//                break
//            }
        }
        print("result: \(grid.values.filter { $0 == -1 }.count)")
    }

    func setupGrid() -> (grid: [Point: Int], maxX: Int, minX: Int, maxY: Int, minY: Int) {
        var grid: [Point: Int] = [:]
        var maxX: Int = 0
        var maxY: Int = 0
        var minX: Int = .max
        var minY: Int = .max
        for (idx,line) in input.split(separator: "\n").enumerated() where !line.isEmpty {
            var lastPoint: Point?
            for point in line.components(separatedBy: " -> ") {
                let values = point.split(separator: ",")
                let x = Int(values[0])!
                let y = Int(values[1])!

                guard let last = lastPoint else {
                    lastPoint = Point(x: x, y: y)
                    continue
                }

                let newPoint = Point(x: x, y: y)
                if last.x == x {
                    let range: ClosedRange<Int> = y < last.y ? y...last.y : (last.y)...y
                    for yValue in range {
                        grid[Point(x: x, y: yValue)] = idx
                    }
                } else if last.y == y {
                    let range: ClosedRange<Int> = x < last.x ? x...last.x : (last.x)...x
                    for xValue in range {
                        grid[Point(x: xValue, y: y)] = idx
                    }
                } else {
                    fatalError("Unexpected diagonal line")
                }
                maxX = max(maxX, x)
                maxY = max(maxY, y)
                minX = min(minX, x)
                minY = min(minY, y)
                lastPoint = newPoint
            }
        }
        return (grid, maxX, minX, maxY, minY)
    }
}

extension Dictionary where Key == Point, Value == Int {
    func prettyPrint(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) {
        for y in yRange {
            for x in xRange {
                let point = self[Point(x: x, y: y)]
                let char: Character
                switch point {
                case .none: char = "."
                case -1: char = "o"
                default: char = "#"
                }
                print(char , terminator: "")
            }
            print()
        }
    }
}
