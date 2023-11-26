//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 22.12.22.
//

import Foundation

class Day22: Day {
    var day: Int { 22 }
    var grid: [Point: Character]
    let movement: String
    let maxY: Int
    let maxX: Int
    let initial: Point

    let cubeDimensions: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = exampleInput
            self.cubeDimensions = 4
            maxX = 4 * 4
            maxY = 3 * 4
        } else {
            inputString = try InputGetter.getInput(for: 22, part: .first)
            self.cubeDimensions = 50
            maxX = 4 * 50
            maxY = 4 * 50
        }

        let split = inputString
            .split(separator: "\n")
            .filter { !$0.isEmpty }

        movement = String(split.last!)

        var grid: [Point: Character] = [:]
        var initial: Point?
        for (y, row) in split.enumerated().dropLast(1) {
            for (x, char) in row.enumerated() where char != " " {
                if initial == nil {
                    initial = Point(x: x, y: y)
                }
                let point = Point(x: x, y: y)
                grid[point] = char
            }
        }

        self.grid = grid
        self.initial = initial!
    }

    func runPart1() throws {
        grid.prettyPrint(maxX: maxX, maxY: maxY)

        let (end, dir) = move(start: initial, direction: .right, isCube: false)
        print("result: \(1000 * (end.y + 1) + 4 * (end.x + 1) + dir.rawValue)")
    }

    func runPart2() throws {
//        grid.prettyPrint(maxX: maxX, maxY: maxY)

        let (end, dir) = move(start: initial, direction: .right, isCube: true)
        print("result: \(1000 * (end.y + 1) + 4 * (end.x + 1) + dir.rawValue)")
    }

    func move(start: Point, direction: Direction, isCube: Bool) -> (Point, Direction) {
        var currMoveIdx = movement.startIndex
        var turnIdx = movement[currMoveIdx...].firstIndex(where: { !$0.isNumber })
        var position = start
        var direction: Direction = direction
        var stepsTaken: [Substring] = []
        var count = 0
        
        while let turnI = turnIdx {
            let moveCount = Int(movement[currMoveIdx..<turnI])!

            for _ in 0..<moveCount {
                let res = wrapAround(start: position, direction: direction, isCube: isCube)
                let element = grid[res.0]

                if element == "#" {
                    break
                } else {
                    position = res.0
                }
                direction = res.1
                grid[position] = direction.arrow
            }

            if turnI == movement.endIndex {
                stepsTaken.append(movement[currMoveIdx..<turnI])
            } else {
                stepsTaken.append(movement[currMoveIdx...turnI])
            }

            guard turnI != movement.endIndex else {
                break
            }

            let turn = movement[turnI]
            switch turn {
            case "R":
                direction = direction.turningRight()
            case "L":
                direction = direction.turningLeft()
            default:
                fatalError()
            }

//            grid[position] = direction.arrow

//            grid.prettyPrint(maxX: maxX, maxY: maxY, replacing: [position: direction.arrow])

            print(count, position.x, position.y, direction.rawValue)
            count += 1
            currMoveIdx = movement.index(after: turnI)
            turnIdx = movement[currMoveIdx...].firstIndex(where: { !$0.isNumber }) ?? movement.endIndex
        }

//        print(stepsTaken)
//        assert(stepsTaken.joined(separator: "") == movement)

        return (position, direction)
    }

    func wrapAround(start: Point, direction: Direction, isCube: Bool) -> (Point, Direction) {
        let offsetPoint: Point
        switch direction {
        case .right: offsetPoint = Point(x: 1, y: 0)
        case .down: offsetPoint = Point(x: 0, y: 1)
        case .left: offsetPoint = Point(x: -1, y: 0)
        case .up: offsetPoint = Point(x: 0, y: -1)
        }
        let p = start + offsetPoint
        // wrap around
        if isCube {
            switch (start.x, start.y, p.x, p.y) {
            // MARK: - area 1
            case (_, 0..<cubeDimensions, (2 * cubeDimensions)..<(3 * cubeDimensions), 0..<cubeDimensions):
                return (p, direction)
                
            case (_, 0..<cubeDimensions, .min..<(2 * cubeDimensions), _):
                // going left
                // x 8  y 0 -> x 4 y 4
                // x 8  y 1 -> x 5 y 4
                // x 8  y 2 -> x 6 y 4
                // x 8  y 3 -> x 7 y 4
//                print("x underflow going from 1 to 3")
                let y = cubeDimensions
                let x = cubeDimensions + start.y
                return (.init(x: x, y: y), .down)

            case (_, 0..<cubeDimensions, (3 * cubeDimensions)...(.max), _):
                // going right
                // x 11  y 3 -> x 15 y 8
                // x 11  y 2 -> x 15 y 9
                // x 11  y 1 -> x 15 y 10
                // x 11  y 0 -> x 15 y 11
//                print("x overflow going from 1 to 6")
                let x = 4 * cubeDimensions - 1
                let y = 3 * cubeDimensions - start.y - 1
                return (.init(x: x, y: y), .left)

            case (_, 0..<cubeDimensions, _, .min..<0):

//                print("y underflow going from 1 to 2")
//                return (grid.filter { $0.key.x == start.x }.max { $0.key.y < $1.key.y }!.key, .up)
                // x 8  y 0 -> x 3 y 4
                // x 9  y 0 -> x 2 y 4
                // x 10 y 0 -> x 1 y 4
                // x 11 y 0 -> x 0 y 4
                let x = (3 * cubeDimensions - 1) - start.x
                let y = cubeDimensions
                return(.init(x: x, y: y), .down)

            case (_, 0..<cubeDimensions, _, (cubeDimensions)...(.max)):
                return (p, direction)

            // MARK: - area 2
            case (0..<cubeDimensions, cubeDimensions..<(2 * cubeDimensions), 0..<cubeDimensions, cubeDimensions..<(2 * cubeDimensions)):
                return (p, direction)
            case (0..<cubeDimensions, cubeDimensions..<(2 * cubeDimensions), .min..<0, _):
                // going left to 6
                // x 0 y 4 -> x 15 y 11
                // x 0 y 5 -> x 14 y 11
                // x 0 y 6 -> x 13 y 11
                // x 0 y 7 -> x 12 y 11
                let x = 3 * cubeDimensions + (2 * cubeDimensions - start.y - 1)
                let y = 3 * cubeDimensions - 1
                return (.init(x: x, y: y), .up)
            case (0..<cubeDimensions, cubeDimensions..<(2 * cubeDimensions), cubeDimensions...(.max), _):
                // going right to 3
                return (p, direction)
            case (0..<cubeDimensions, cubeDimensions..<(2 * cubeDimensions), _, .min..<cubeDimensions):
                // going up to 1
                // x 0 y 4 -> x 11 y 0
                // x 1 y 4 -> x 10 y 0
                // x 2 y 4 -> x 9  y 0
                // x 3 y 4 -> x 8  y 0
//                print("y underflow going from 2 to 1")
                let x = 2 * cubeDimensions + (cubeDimensions - start.x - 1)
                let y = 0
                return (.init(x: x, y: y), .down)
            case (0..<cubeDimensions, cubeDimensions..<(2 * cubeDimensions), _, (2 * cubeDimensions)...(.max)):
                // going down to 5
                // x 0 y 7 -> x 11 y 11
                // x 1 y 7 -> x 10 y 11
                // x 2 y 7 -> x 9  y 11
                // x 3 y 7 -> x 8  y 11
//                print("y overflow going from 2 to 5")
                let x = 2 * cubeDimensions + (cubeDimensions - start.x) - 1
                let y = 3 * cubeDimensions - 1
                return (.init(x: x, y: y), .up)


            // MARK: - area 3
            case (cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions)):
                return (p, direction)
            case (cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), .min..<cubeDimensions, _):
                return (p, direction)
            case (cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), (2 * cubeDimensions)...(.max), _):
                return (p, direction)
            case (cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), _, .min..<cubeDimensions):
//                print("y underflow going from 3 to 1")
                // x 4 y 4 -> x 8  y 0
                // x 5 y 4 -> x 8  y 1
                // x 6 y 4 -> x 8  y 2
                // x 7 y 4 -> x 8  y 3
                let x = 2 * cubeDimensions
                let y = start.x - cubeDimensions
                return (.init(x: x, y: y), .right)
            case (cubeDimensions..<(2 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), _, (2 * cubeDimensions)...(.max)):
//                print("y overflow going from 3 to 5")
                // x 4 y 7 -> x 8  y 11
                // x 5 y 7 -> x 8  y 10
                // x 6 y 7 -> x 8  y 9
                // x 7 y 7 -> x 8  y 8
                let x = 2 * cubeDimensions
                let y = 2 * cubeDimensions + 2 * cubeDimensions - start.x - 1
                return (.init(x: x, y: y), .right)

            // MARK: - area 4
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions)):
                return (p, direction)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), .min..<(2 * cubeDimensions), _):
                return (p, direction)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), (3 * cubeDimensions)...(.max), _):
//                print("x overflow going from 4 to 6")
                // going right
                // x 11 y 4 - > x 15 y 8
                // x 11 y 5 - > x 14 y 8
                // x 11 y 6 - > x 13 y 8
                // x 11 y 7 - > x 12 y 8
                let x = (3 * cubeDimensions) + (2 * cubeDimensions - start.y - 1)
                let y = 2 * cubeDimensions
                return (.init(x: x, y: y), .down)

            case ((2 * cubeDimensions)..<(3 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), _, .min..<cubeDimensions):
                return (p, direction)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), cubeDimensions..<(2 * cubeDimensions), _, (2 * cubeDimensions)...(.max)):
                return (p, direction)

            // MARK: - area 5
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions)):
                return (p, direction)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), .min..<(2 * cubeDimensions), _):
//                print("x underflow going from 5 to 3")
                // going left
                // x 8 y 8  - > x 7 y 7
                // x 8 y 9  - > x 6 y 7
                // x 8 y 10 - > x 5 y 7
                // x 8 y 11 - > x 4 y 7
                let x = cubeDimensions + (3 * cubeDimensions - start.y - 1)
                let y = 2 * cubeDimensions - 1
                return (.init(x: x, y: y), .up)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), (3 * cubeDimensions)...(.max), _):
//                print("x overflow going from 5 to 6")
                return (p, direction)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), _, .min..<(2 * cubeDimensions)):
//                print("y underflow going from 5 to 4")
                return (p, direction)
            case ((2 * cubeDimensions)..<(3 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), _, (2 * cubeDimensions)...(.max)):
//                print("y overflow going from 5 to 2")
                // x 8  y 11 -> x 3 y 7
                // x 9  y 11 -> x 2 y 7
                // x 10 y 11 -> x 1 y 7
                // x 11 y 11 -> x 0 y 7
                let y = 2 * cubeDimensions - 1
                let x = 3 * cubeDimensions - start.x - 1
                return (.init(x: x, y: y), .up)

            // MARK: - area 6
            case ((3 * cubeDimensions)..<(4 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), (3 * cubeDimensions)..<(4 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions)):
                return (p, direction)
            case ((3 * cubeDimensions)..<(4 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), .min..<(3 * cubeDimensions), _):
                return (p, direction)
            case ((3 * cubeDimensions)..<(4 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), (4 * cubeDimensions)...(.max), _):
//                print("y overflow going from 6 to 1")
                // x 15 y 8  -> x 11 y 3
                // x 15 y 9  -> x 11 y 2
                // x 15 y 10 -> x 11 y 1
                // x 15 y 11 -> x 11 y 0
                let y = (3 * cubeDimensions - 1) - start.y
                let x = 3 * cubeDimensions - 1
                return (.init(x: x, y: y), .left)
            case ((3 * cubeDimensions)..<(4 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), _, .min..<(2 * cubeDimensions)):
//                print("y underflow going from 6 to 4")
                // x 12 y 8  -> x 11 y 7
                // x 13 y 8  -> x 11 y 6
                // x 14 y 8  -> x 11 y 5
                // x 15 y 8  -> x 11 y 4
                let y = (5 * cubeDimensions - 1) - start.x
                let x = 3 * cubeDimensions - 1
                return (.init(x: x, y: y), .left)
            case ((3 * cubeDimensions)..<(4 * cubeDimensions), (2 * cubeDimensions)..<(3 * cubeDimensions), _, (3 * cubeDimensions)...(.max)):
//                print("y overflow going from 6 to 2")
                // x 12 y 11 -> x 0 y 7
                // x 13 y 11 -> x 0 y 6
                // x 14 y 11 -> x 0 y 5
                // x 15 y 11 -> x 0 y 4
                let y = (5 * cubeDimensions - 1) - start.x
                let x = 0
                return (.init(x: x, y: y), .right)
            default:
                fatalError()
            }
        } else {
            if grid[p] == nil {
                switch direction {
                case .right: return (grid.filter { $0.key.y == start.y }.min { $0.key.x < $1.key.x }!.key, direction)
                case .down: return (grid.filter { $0.key.x == start.x }.min { $0.key.y < $1.key.y }!.key, direction)
                case .left: return (grid.filter { $0.key.y == start.y }.max { $0.key.x < $1.key.x }!.key, direction)
                case .up: return (grid.filter { $0.key.x == start.x }.max { $0.key.y < $1.key.y }!.key, direction)
                }
            }
            return (p, direction)
        }
    }

    enum Direction: Int {
        case right = 0, down = 1, left = 2, up = 3

        func turningRight() -> Direction {
            switch self {
            case .right: return .down
            case .down: return .left
            case .left: return .up
            case .up: return .right
            }
        }

        func turningLeft() -> Direction {
            switch self {
            case .right: return .up
            case .down: return .right
            case .left: return .down
            case .up: return .left
            }
        }

        var arrow: Character {
            switch self {
            case .right: return ">"
            case .down: return "v"
            case .left: return "<"
            case .up: return "^"
            }
        }
    }
}

fileprivate extension Dictionary where Key == Point, Value == Character {
    func prettyPrint(maxX: Int, maxY: Int, replacing: [Point: Character] = [:]) {
        for y in 0..<maxY {
            for x in 0..<maxX {
                var toPrint = self[.init(x: x, y: y)] ?? " "
                if let r = replacing[.init(x: x, y: y)] {
                    toPrint = r
                }
                print(toPrint, terminator: "")
            }
            print()
        }
    }
}

fileprivate let exampleInput = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
"""
