//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 24.12.22.
//

import Foundation

class Day24: Day {
    var day: Int { 24 }
    let height: Int
    let width: Int
    let blizzards: [Point: [BlizzardDir]]
    let startPosition: Point
    let destination: Point

    var mapBlizzardStates: [[Point: [BlizzardDir]]: [Point: [BlizzardDir]]] = [:]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = exampleInput
        } else {
            inputString = try InputGetter.getInput(for: 24, part: .first)
        }
        var blizzards: [Point: [BlizzardDir]] = [:]
        var maxX: Int = 0
        var maxY = 0
        for (y, row) in inputString.split(separator: "\n").dropFirst().enumerated() where !row.isEmpty  {
            maxY = max(maxY, y)
            for (x, char) in row.dropFirst().enumerated() {
                maxX = max(maxX, x)
                if let dir = BlizzardDir(rawValue: char) {
                    blizzards[.init(x: x, y: y)] = [dir]
                }
            }
        }

        self.blizzards = blizzards
        self.width = maxX
        self.height = maxY
        self.startPosition = Point(x: 0, y: -1)
        self.destination = Point(x: maxX - 1, y: maxY)
    }

    func runPart1() throws {
        let result = runBFS(startPosition: startPosition, initialBlizzards: blizzards, goal: destination)
        print("found: ", result.0)
    }

    func runPart2() throws {
        let firstGo = runBFS(startPosition: startPosition, initialBlizzards: blizzards, goal: destination)
        print("first time there: \(firstGo.0)")
        let goingBack = runBFS(startPosition: destination, initialBlizzards: firstGo.1, goal: startPosition)
        print("got back: \(goingBack.0)")
        let andThroughAgain = runBFS(startPosition: startPosition, initialBlizzards: goingBack.1, goal: destination)

        print("took: ", firstGo.0, goingBack.0, andThroughAgain.0, firstGo.0 + goingBack.0 + andThroughAgain.0)
    }

    struct State: Hashable {
        let startPoint: Point
        let blizzards: [Point: [BlizzardDir]]
        let currentPath: [Point]
    }

    var cache: [State: [Point]] = [:]

    let moveOffsets: [Point] = [ .init(x: -1, y: 0), .init(x: 1, y: 0), .init(x: 0, y: -1), .init(x: 0, y: 1), .init(x: 0, y: 0)]

    func runBFS(startPosition: Point, initialBlizzards: [Point: [BlizzardDir]], goal: Point) -> (Int, [Point: [BlizzardDir]]) {
        var time = 0
        var currentBlizzard = initialBlizzards
        var found = false
        var currentPositions: Set<Point> = [startPosition]
        while !found {
            print("step: ", time, currentPositions.count)
            let newBlizzards = advance(blizzards: currentBlizzard)
            var moves: Set<Point> = []
            for point in currentPositions {
                for offset in moveOffsets {
                    let newPoint = point + offset
                    if newPoint != goal && (newPoint.x < 0 || newPoint.y < 0 || newPoint.x >= width || newPoint.y >= height) {
                        if newPoint != startPosition {
                            continue
                        }
                    }

                    if newBlizzards[newPoint]?.isEmpty ?? true {
                        if newPoint == goal {
                            found = true
                            break
                        }
                        moves.insert(newPoint)
                    }
                }
            }

            currentPositions = moves
            currentBlizzard = newBlizzards
            time += 1
        }

        return (time, currentBlizzard)
    }

    var advancedCache: [[Point: [BlizzardDir]]: [Point: [BlizzardDir]]] = [:]
    func advance(blizzards: [Point: [BlizzardDir]]) -> [Point: [BlizzardDir]] {
        if let cached = advancedCache[blizzards] {
//            print("advance cache hit")
            return cached
        }
        var new: [Point: [BlizzardDir]] = [:]
        for point in blizzards {
            for blizzard in point.value {
                let offsetPoint = blizzard.offset
                var newX: Int = (point.key.x + offsetPoint.x) % width
                if newX < 0 {
                    newX = width - 1
                }
                var newY: Int = (point.key.y + offsetPoint.y) % height
                if newY < 0 {
                    newY = height - 1
                }
                new[.init(x: newX, y: newY), default: []].append(blizzard)
            }
        }
        advancedCache[blizzards] = new
        return new
    }

    enum BlizzardDir: Character {
        case left = "<"
        case up = "^"
        case right = ">"
        case down = "v"

        var offset: Point {
            switch self {
            case .left: return .init(x: -1, y: 0)
            case .right: return .init(x: 1, y: 0)
            case .up: return .init(x: 0, y: -1)
            case .down: return .init(x: 0, y: 1)
            }
        }
    }
}

extension Dictionary where Key == Point, Value == [Day24.BlizzardDir] {
    func prettyPrint(width: Int, height: Int) {
        for y in 0..<height {
            for x in 0..<width {
                if let dir = self[.init(x: x, y: y)] {
                    if dir.count > 1 {
                        print(dir.count, terminator: "")
                    } else if dir.count == 1 {
                        print(dir.first!.rawValue, terminator: "")
                    } else {
                        print("?", terminator: "")
                    }
                } else {
                    print(".", terminator: "")
                }
            }
            print()
        }
        print()
    }
}
//
//fileprivate let exampleInput = """
//#.#####
//#.....#
//#>....#
//#.....#
//#...v.#
//#.....#
//#####.#
//"""

fileprivate let exampleInput = """
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
"""
