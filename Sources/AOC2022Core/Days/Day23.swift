//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 23.12.22.
//

import Foundation

class Day23: Day {
    var day: Int { 23 }
    let input: Set<Point>

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = exampleInput
        } else {
            inputString = try InputGetter.getInput(for: 23, part: .first)
        }
        var grid: Set<Point> = []
        for (y, row) in inputString.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() where char == "#" {
                grid.insert(.init(x: x, y: y))
            }
        }

        self.input = grid
    }

    func runPart1() throws {
        let res = simulate(rounds: 10)

        let width = res.maxX - res.minX + 1
        let height = res.maxY - res.minY + 1

        print("res: ", res, (width * height) - res.grid.count )
    }

    func runPart2() throws {
        let start = CFAbsoluteTimeGetCurrent()
        let _ = simulate(rounds: .max)
        print("took: ", CFAbsoluteTimeGetCurrent() - start)
    }



    func simulate(rounds: Int) -> (grid: Set<Point>, minX: Int, maxX: Int, minY: Int, maxY: Int) {
        let allAround = Set(Direction.allCases.flatMap { $0.offsets })

        var grid = input
        var startDirection = 0

        for i in 0..<rounds {
            if i % 100 == 0 {
                print(i)
            }
            var moveDict: [Point: Int] = [:]
            var elfMoves: [Point: Point] = [:]
            // check where to go
            for elf in grid {
                if allAround.map({ $0 + elf }).filter({ grid.contains($0) }).isEmpty {
                    continue
                }
                for direction in Direction.allCases[startDirection...] + Direction.allCases[..<startDirection] {
                    if direction.offsets.filter({ grid.contains($0 + elf) }).isEmpty {
                        elfMoves[elf] = direction.movOffset + elf
                        moveDict[direction.movOffset + elf, default: 0] += 1
                        break
                    }
                }
            }

            if elfMoves.isEmpty {
                // no one is moving anymore
                print("no one is moving anymore", i)
                break
            }

            startDirection = (startDirection + 1) % Direction.allCases.count

            let elfCount = grid.count
            for elfMove in elfMoves where moveDict[elfMove.value]! == 1 {
                grid.remove(elfMove.key)
                grid.insert(elfMove.value)

            }

            assert(grid.count == elfCount)
        }
        let minX = grid.map { $0.x }.min()!
        let minY = grid.map { $0.y }.min()!
        let maxX = grid.map { $0.x }.max()!
        let maxY = grid.map { $0.y }.max()!
        return (grid, minX, maxX, minY, maxY)
    }

    enum Direction: Int, CaseIterable {
        case north = 0, south = 1, west = 2, east = 3

        var offsets: [Point] {
            switch self {
            case .north: return [Point(x: -1, y: -1), Point(x: 0, y: -1), Point(x: 1, y: -1)]
            case .south: return [Point(x: -1, y: 1), Point(x: 0, y: 1), Point(x: 1, y: 1)]
            case .west: return [Point(x: -1, y: -1), Point(x: -1, y: 0), Point(x: -1, y: 1)]
            case .east: return [Point(x: 1, y: -1), Point(x: 1, y: 0), Point(x: 1, y: 1)]
            }
        }

        var movOffset: Point {
            switch self {
            case .north: return Point(x: 0, y: -1)
            case .south: return Point(x: 0, y: 1)
            case .west: return Point(x: -1, y: 0)
            case .east: return Point(x: 1, y: 0)
            }
        }
    }
}

extension Set where Element == Point {
    func prettyPrint(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) {
        for y in yRange {
            for x in xRange {
                let toPrint = self.contains(Point(x: x, y: y)) ? "#" : "."
                print(toPrint, terminator: "")
            }
            print()
        }
        print()
    }
}


fileprivate let exampleInput = """
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"""
