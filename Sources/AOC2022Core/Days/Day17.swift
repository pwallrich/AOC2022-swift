//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 17.12.22.
//

import Foundation

class Day17: Day {
    var day: Int { 17 }
    let input: [Character]

    var currentTile: Tile = .horizontalLine
    var grid: [Point: Character] = [:]
    var currentStartPoint = 3
    var currentWindIndex = 0
    var moveCount = 0
    var currentMax = 0

    let alphabet: [Character] = {
        var result: [Character] = []
        let asciiStartUpper = Character("A").asciiValue!
        for i in 0..<26 {
            result.append(Character(UnicodeScalar(asciiStartUpper + UInt8(i))))
        }
        let asciiStartLower = Character("a").asciiValue!
        for i in 0..<26 {
            result.append(Character(UnicodeScalar(asciiStartLower + UInt8(i))))
        }
        return result
    }()

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
        } else {
            inputString = try InputGetter.getInput(for: 17, part: .first)
        }

        self.input = inputString.map { $0 }.filter { !$0.isWhitespace }

        print(alphabet)
    }

    func runPart1() throws {
        var start = CFAbsoluteTimeGetCurrent()
        for i in 0..<2022 {
            moveDown()
            if i % 1_00 == 0 {
                let end = CFAbsoluteTimeGetCurrent()
                print("iteration ", i, end - start)
                start = end
            }

        }
        grid.prettyPrint(height: currentStartPoint + currentTile.tile.count)
        print(currentStartPoint - 3)
    }

    func runPart2() throws {
        var start = CFAbsoluteTimeGetCurrent()
        var i = 0
        var cycleCheck: (Bool, Int)!
        while i < 1_000_000_000_000 {
            let startTile = currentTile
            let startWind = currentWindIndex
            moveDown()
            if i % 1_000 == 0 {
                let end = CFAbsoluteTimeGetCurrent()
                print("iteration ", i, end - start)
                start = end
            }
            cycleCheck = checkIfCycle(startTile: startTile, startWind: startWind, move: i)
            if cycleCheck.0 {
                break
            }
            i += 1
        }
//        grid.prettyPrint(height: currentStartPoint + currentTile.tile.count)

        let rocksFallen = i - cycleCheck.1
        let heightOfLoop = (currentStartPoint - 3) - rockHeightCache[cycleCheck.1]
        let remainingRocksToFall = (1_000_000_000_000 - i)
        let remainingInLoop = (remainingRocksToFall % rocksFallen)

        let firstIndex = remainingInLoop + cycleCheck.1

        let highest = currentStartPoint - 3 + (remainingRocksToFall / rocksFallen) * heightOfLoop + rockHeightCache[firstIndex] - rockHeightCache[cycleCheck.1] - 1

        print(highest)
    }
    struct CacheKey: Hashable {
        let tile: Tile
        let startWind: Int
        let endWind: Int
    }
    var cycleCache: [CacheKey: [Int]] = [:]
    var rockHeightCache: [Int] = []

    func checkIfCycle(startTile: Tile, startWind: Int, move: Int) -> (Bool, Int) {
        rockHeightCache.append(currentStartPoint - 3)
        var isCycle = (false, 0)
        // check if is repating
        if var values = cycleCache[.init(tile: startTile, startWind: startWind, endWind: currentWindIndex)], values.count > 1 {
            print("found multiple")
            let last = values.popLast()!
            let secondLast = values.popLast()!
            // stable loop
            if last - secondLast == move - last {
                isCycle = (true, last)
            }
        }

        cycleCache[.init(tile: startTile, startWind: startWind, endWind: currentWindIndex), default: []].append(move)

        return isCycle
    }

    func prettyPrint(startPosition: Point) {
        for (yOffset, row) in currentTile.tile.enumerated() {
            for (xOffset, item) in row.enumerated() where item != "." {
                let point = Point(x: startPosition.x + xOffset, y: startPosition.y + yOffset)
                if grid[point] == nil {
                    grid[point] = "@"
                }
            }
        }
        grid.prettyPrint(height: currentStartPoint + currentTile.tile.count)
        for (yOffset, row) in currentTile.tile.enumerated() {
            for (xOffset, item) in row.enumerated() where item != "." {
                let point = Point(x: startPosition.x + xOffset, y: startPosition.y + yOffset)
                if grid[point] == "@" {
                    grid[point] = nil
                }
            }
        }
    }

    @discardableResult
    func moveDown() -> Point {
        let tile = currentTile.tile
        var startPosition = Point(x: 2, y: currentStartPoint)

        var stopped = false
        while !stopped {
//            prettyPrint(startPosition: startPosition)
            moveWithWind(startPosition: &startPosition)
//            prettyPrint(startPosition: startPosition)
            stopped = dropIfPossible(startPosition: &startPosition)
//            prettyPrint(startPosition: startPosition)
        }

        let charIndex = moveCount % alphabet.count

        let charToInsert = alphabet[charIndex]
        for (yOffset, row) in tile.enumerated() {
            for (xOffset, item) in row.enumerated() where item != "." {
                grid[Point(x: startPosition.x + xOffset, y: startPosition.y + yOffset)] = charToInsert
            }
        }

        currentMax = max(startPosition.y + currentTile.tile.count, currentMax)

        currentStartPoint = currentMax + 3
        currentTile = currentTile.next

        moveCount += 1

        return startPosition
    }

    func moveWithWind(startPosition: inout Point) {
        // push with wind if possible
        let direction = input[currentWindIndex]
        // only if it can actually move to the right
        if direction == ">" && startPosition.x + currentTile.width < 7 {
            var toMove = 1
            // check for each row if it is blocked
            for y in currentTile.tile.enumerated() {
                // get first item in the row, that is actually visible
                let firstIndex = y.element.lastIndex { $0 != "." }!
                // check if the point in that row will is blocked to the right
                let currentY = startPosition.y + y.offset
                let currentX = startPosition.x + firstIndex + 1
                let point = Point(x: currentX, y: currentY)
                if grid[point] != nil {
                    toMove = 0
                    break
                }
            }
            startPosition.x += toMove
        } else if direction == "<" && startPosition.x > 0 {
            var toMove = -1
            for y in currentTile.tile.enumerated() {
                let firstIndex = y.element.firstIndex { $0 != "." }!
                let currentY = startPosition.y + y.offset
                let currentX = startPosition.x + firstIndex - 1
                let point = Point(x: currentX, y: currentY)
                if grid[point] != nil {
                    toMove = 0
                    break
                }
            }

            startPosition.x += toMove
        }
        currentWindIndex = (currentWindIndex + 1) % input.count
    }

    func dropIfPossible(startPosition: inout Point) -> Bool {
        var stopped: Bool = false

        if currentTile == .plus {
            let toCheck: Set<Point> = [.init(x: 1, y: 0), .init(x: 0, y: 1), .init(x: 2, y: 1)]
            for (offset) in toCheck {
                var toCheck = startPosition + offset
                toCheck.y -= 1
                if grid[toCheck] != nil {
                    stopped = true
                    break
                }
            }
        } else {
            // hitTest
            for (offset, item) in currentTile.tile.first!.enumerated() where item != "." {
                let pointOffset = Point(x: offset, y: -1)
                if grid[startPosition + pointOffset] != nil {
                    stopped = true
                    break
                }
            }
        }
        guard startPosition.y > 0 && !stopped else {
            return true
        }

        startPosition.y -= 1

        return false
    }

}

fileprivate extension Dictionary where Key == Point, Value == Character {
    func prettyPrint(height: Int) {
        for y in 0...height+1 {
            print(String(format: "%04d", height - y), terminator: "")
            for x in -1...7 {
                if height - y == -1 {
                    print("-", terminator: "")
                } else if x == -1 || x == 7   {
                    print("|", terminator: "")
                } else if let value = self[Point(x: x, y: height - y)] {
                    print(value, terminator: "")
                } else {
                    print(" ", terminator: "")
                }
            }
            print()
        }
    }
}

enum Tile {
    case horizontalLine
    case plus
    case mirroredL
    case verticalLine
    case square

    var next: Tile {
        switch self {
        case .horizontalLine: return .plus
        case .plus: return .mirroredL
        case .mirroredL: return .verticalLine
        case .verticalLine: return .square
        case .square: return .horizontalLine
        }
    }

    var tile: [[Character]] {
        switch self {
        case .horizontalLine:
            return [["#", "#", "#", "#"]]
        case .plus:
            return [
                [".", "#", "."],
                ["#", "#", "#"],
                [".", "#", "."],
            ].reversed()
        case .mirroredL:
            return [
                [".", ".", "#"],
                [".", ".", "#"],
                ["#", "#", "#"],
            ].reversed()
        case .verticalLine:
            return [
                ["#"],
                ["#"],
                ["#"],
                ["#"]
            ].reversed()
        case .square:
            return [
                ["#", "#"],
                ["#", "#"]
            ].reversed()
        }
    }

    var tileSet: Set<Point> {
        switch self {
        case .horizontalLine:
            return [
                .init(x: 0, y: 0),
                .init(x: 1, y: 0),
                .init(x: 2, y: 0),
                .init(x: 3, y: 0)
            ]
//            return [["#", "#", "#", "#"]]
        case .plus:
            return [
                .init(x: 1, y: 0),
                .init(x: 0, y: 1),
                .init(x: 1, y: 1),
                .init(x: 2, y: 1),
                .init(x: 1, y: 2)
            ]
//            return [
//                [".", "#", "."],
//                ["#", "#", "#"],
//                [".", "#", "."],
//            ]
        case .mirroredL:
            return [
                .init(x: 2, y: 0),
                .init(x: 2, y: 1),
                .init(x: 0, y: 2),
                .init(x: 1, y: 2),
                .init(x: 2, y: 2)
            ]
//            return [
//                [".", ".", "#"],
//                [".", ".", "#"],
//                ["#", "#", "#"],
//            ]
        case .verticalLine:
            return [
                .init(x: 0, y: 0),
                .init(x: 0, y: 1),
                .init(x: 0, y: 2),
                .init(x: 0, y: 3)
            ]
//            return [
//                ["#"],
//                ["#"],
//                ["#"],
//                ["#"]
//            ]
        case .square:
            return [
                .init(x: 0, y: 0),
                .init(x: 1, y: 0),
                .init(x: 0, y: 1),
                .init(x: 1, y: 1),
            ]
//            return [
//                ["#", "#"],
//                ["#", "#"]
//            ]
        }
    }

    var width: Int {
        switch self {
        case .horizontalLine: return 4
        case .plus: return 3
        case .mirroredL: return 3
        case .verticalLine: return 1
        case .square: return 2
        }
    }
}

extension Tile: CustomStringConvertible {
    var description: String {
        switch self {
        case .horizontalLine: return "-"
        case .plus: return "+"
        case .mirroredL: return "L"
        case .verticalLine: return "|"
        case .square: return "#"
        }
    }
}
