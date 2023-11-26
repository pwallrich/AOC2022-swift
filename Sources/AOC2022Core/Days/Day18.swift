//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 18.12.22.
//

import Foundation

class Day18: Day {
    var day: Int { 18 }
    let input: Set<Point3>

    let testInput: Bool

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "2,2,2\n1,2,2\n3,2,2\n2,1,2\n2,3,2\n2,2,1\n2,2,3\n2,2,4\n2,2,6\n1,2,5\n3,2,5\n2,1,5\n2,3,5"
//            inputString = "1,1,1\n2,1,1"
        } else {
            inputString = try InputGetter.getInput(for: 18, part: .first)
        }

        var res: Set<Point3> = []

        for row in inputString.split(separator: "\n") where !row.isEmpty {
            let items = row.split(separator: ",")
            let point = Point3(x: .init(items[0])!, y: .init(items[1])!, z: .init(items[2])!)
            res.insert(point)
        }

        self.input = res
        self.testInput = testInput
    }

    func runPart1() throws {
//        print(input)

        let res = getExposedCount(input: input)

        print("part 1: \(res)")

        if testInput {
            assert(res == 64)
        }
    }

    func runPart2() throws {
        let start = CFAbsoluteTimeGetCurrent()
        let res = getExposedCount(removingNotReachable: true, input: input)
        let end = CFAbsoluteTimeGetCurrent()
        print("part2: \(res)", end - start)
    }

    struct Side: Hashable {
        let points: Set<Point3>
    }

    let sideOffsets: [[Point3]] = [
        [.init(x: 0, y: 0, z: 0), .init(x: 1, y: 0, z: 0), .init(x: 1, y: 0, z: 1), .init(x: 0, y: 0, z: 1)],

        [.init(x: 0, y: 0, z: 0), .init(x: 0, y: 1, z: 0), .init(x: 0, y: 1, z: 1), .init(x: 0, y: 0, z: 1)],

        [.init(x: 0, y: 0, z: 0), .init(x: 1, y: 0, z: 0), .init(x: 1, y: 1, z: 0), .init(x: 0, y: 1, z: 0)],

        [.init(x: 1, y: 0, z: 0), .init(x: 1, y: 1, z: 0), .init(x: 1, y: 1, z: 1), .init(x: 1, y: 0, z: 1)],

        [.init(x: 1, y: 1, z: 0), .init(x: 0, y: 1, z: 0), .init(x: 0, y: 1, z: 1), .init(x: 1, y: 1, z: 1)],

        [.init(x: 0, y: 0, z: 1), .init(x: 1, y: 0, z: 1), .init(x: 1, y: 1, z: 1), .init(x: 0, y: 1, z: 1)],
    ]



    func getExposedCount(removingNotReachable: Bool = false, input: Set<Point3>) -> Int {
        var sides: [Side: Int] = [:]

        var maxX = 0
        var maxZ = 0
        var maxY = 0

        for cube in input {
            for sideOffsets in sideOffsets {
                let sidePoint = sideOffsets.map { $0 + cube }
                let side = Side(points: Set(sidePoint))
                maxX = max(sidePoint.map { $0.x }.max()!, maxX)
                maxY = max(sidePoint.map { $0.y }.max()!, maxY)
                maxZ = max(sidePoint.map { $0.z }.max()!, maxZ)
                sides[side, default: 0] += 1
            }
        }

        guard removingNotReachable else {
            return sides.filter { $0.value == 1 }.count
        }
        return floodFill(cubeStart: .init(x: 0, y: 0, z: 0), length: max(maxZ, maxY, maxX) + 1, sides: sides)
    }

    struct Cube {
        let start: Point3
        let points: Set<Point3>

        init(start: Point3) {
            let points = cubeOffsets.map { start + $0 }
            self.points = Set(points)
            self.start = start
        }
    }

    func floodFill(cubeStart: Point3, length: Int, sides: [Side: Int]) -> Int {
        var grid: [Point3: Int] = Dictionary(uniqueKeysWithValues: input.map { ($0, 1) })
        var toFill: Set<Point3> = [cubeStart]
        var visited: Set<Point3> = []

        while let current = toFill.popFirst() {
            visited.insert(current)
            if grid[current] == nil {
                let offsets: [Point3] = [ .init(x: 1, y: 0, z: 0), .init(x: 0, y: 1, z: 0), .init(x: 0, y: 0, z: 1), .init(x: -1, y: 0, z: 0), .init(x: 0, y: -1, z: 0), .init(x: 0, y: 0, z: -1)]
                grid[current] = 0

                let newPoints = offsets
                    .map { $0 + current }
                    .filter { 0...length ~= $0.x && 0...length ~= $0.y && 0...length ~= $0.z }
                    .filter { !visited.contains($0) }

                toFill = toFill.union(newPoints)
            }
        }

        var newInput = input
        for x in 0...length {
            for y in 0...length {
                for z in 0...length {
                    if grid[.init(x: x, y: y, z: z)] == nil {
                        newInput.insert(.init(x: x, y: y, z: z))
                    }
                }
            }
        }

        let newResult = getExposedCount(input: newInput)

        return newResult
    }

}

struct Point3: Hashable {
    var x: Int
    var y: Int
    var z: Int
}

func +(lhs: Point3, rhs: Point3) -> Point3 {
    Point3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

extension Point3: CustomStringConvertible {
    var description: String {
        "(\(x),\(y),\(z))"
    }
}

fileprivate let cubeOffsets: Set<Point3> = [.init(x: 0, y: 0, z: 0), .init(x: 0, y: 0, z: 1), .init(x: 0, y: 1, z: 0), .init(x: 0, y: 1, z: 1), .init(x: 1, y: 0, z: 0), .init(x: 1, y: 0, z: 1), .init(x: 1, y: 1, z: 0), .init(x: 1, y: 1, z: 1),
]
