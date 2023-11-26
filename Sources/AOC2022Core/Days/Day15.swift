//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 15.12.22.
//

import Foundation

class Day15: Day {
    var day: Int { 15 }
    let beacons: [Point]
    let sensors: [Point: (Point, Int)]
    let testInput: Bool

    fileprivate lazy var initialSet: Set<Int> = Set((0...(testInput ? 20 : 4_000_000)).map { $0 })
    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = testInputString
        } else {
            inputString = try InputGetter.getInput(for: 15, part: .first)
        }

        self.testInput = testInput

        func getValues(from row: String.SubSequence) -> (beacon: Point, sensor: Point) {
            var sensorXStartIndex = row.firstIndex(of: "=")!
            sensorXStartIndex = row.index(after: sensorXStartIndex)
            let sensorXStopIndex = row[sensorXStartIndex...].firstIndex(of: ",")!

            var sensorYStartIndex = row[sensorXStopIndex...].firstIndex(of: "=")!
            sensorYStartIndex = row.index(after: sensorYStartIndex)
            let sensorYStopIndex = row[sensorYStartIndex...].firstIndex(of: ":")!

            let sensorX = Int(row[sensorXStartIndex..<sensorXStopIndex])!
            let sensorY = Int(row[sensorYStartIndex..<sensorYStopIndex])!

            var beaconXStartIndex = row[sensorYStopIndex...].firstIndex(of: "=")!
            beaconXStartIndex = row.index(after: beaconXStartIndex)
            let beaconXStopIndex = row[beaconXStartIndex...].firstIndex(of: ",")!

            var beaconYStartIndex = row[beaconXStopIndex...].firstIndex(of: "=")!
            beaconYStartIndex = row.index(after: beaconYStartIndex)

            let beaconX = Int(row[beaconXStartIndex..<beaconXStopIndex])!
            let beaconY = Int(row[beaconYStartIndex...])!

            return (.init(x: beaconX, y: beaconY), .init(x: sensorX, y: sensorY))
        }
        var beacons: [Point] = []
        var sensors: [Point: (Point, Int)] = [:]

        for row in inputString.split(separator: "\n") where !row.isEmpty {
            let (beacon, sensor) = getValues(from: row)
            beacons.append(beacon)
            sensors[sensor] = (beacon, sensor.manhattanTo(other: beacon))
        }
        self.beacons = beacons
        self.sensors = sensors
    }

    func runPart1() throws {
        let rowToCheck = testInput ? 10 : 2000000

        let beaconsInRow = beacons.filter { $0.y == rowToCheck }

        var points: Set<Int> = []

        for (sensor, beacon) in sensors {
            let manhattan = sensor.manhattanTo(other: beacon.0)
            guard (sensor.y...(sensor.y + manhattan)).contains(rowToCheck) || ((sensor.y - manhattan)...sensor.y).contains(rowToCheck) else {
                continue
            }
            let offsetY = manhattan - abs(sensor.y - rowToCheck)
            let rangeInRow = (sensor.x - offsetY)...(sensor.x + offsetY)
            points = points.union(rangeInRow)
        }

        for beacon in beaconsInRow {
            points.remove(beacon.x)
        }

        print(points.count)

//        print(input)
    }

    func runPart2() throws {
        print("starting part 2")
        let threshold = testInput ? 20 : 4_000_000

        // for every row
        let start = CFAbsoluteTimeGetCurrent()
        for y in 0..<threshold {
            var ranges: [Point: ClosedRange<Int>] = [:]
            for (sensor, (_, manhattan)) in sensors {
                guard sensor.y - manhattan <= y && sensor.y + manhattan >= y else {
                    continue
                }
                let lowerBound = max(sensor.x - (manhattan - abs(y - sensor.y)), 0)
                let upperBound = min(sensor.x + (manhattan - abs(y - sensor.y)), threshold)
                ranges[sensor] = (lowerBound...upperBound)
            }

            var megaRange: ClosedRange<Int>?
            for (sensor, row) in ranges.sorted { $0.value.lowerBound < $1.value.lowerBound } {
                if let range = megaRange {
                    if row.lowerBound > range.upperBound + 1 {
                        print("found \(row.lowerBound) for \(sensor): \(row)", y, range)
                        print(y, range.upperBound + 1, (range.upperBound + 1) * 4000000 + y)
                        let end = CFAbsoluteTimeGetCurrent()
                        print("took: ", end - start)
                        return
                    }
                    megaRange = range.lowerBound...(max(range.upperBound, row.upperBound))
                } else {
                    megaRange = row
                }
            }
        }
    }
}

fileprivate let testInputString = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""
