//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 01.12.22.
//

import Foundation

public final class AOC2022 {
    private let testInput: Bool

    public init(testInput: Bool) throws {
        self.testInput = testInput
    }

    public func run(day: Int, part: Part) throws {
        let day = try getDay(day)

        switch part {
        case .first:
            try day.runPart1()
        case .second:
            try day.runPart2()
        }
    }

    private func getDay(_ number: Int) throws -> Day {
        switch number {
        case 1: return try Day1(testInput: testInput)
        case 2: return try Day2(testInput: testInput)
        case 3: return try Day3(testInput: testInput)
        case 4:
            if #available(iOS 16.0, macOS 13.0, *) {
                return try Day4(testInput: testInput)
            } else {
                fatalError("Day not supported on older os versions. iOS >= 16.0 or macOS >= 13.0 needed")
            }
        case 5:
            if #available(iOS 16.0, macOS 13.0, *) {
                return try Day5(testInput: testInput)
            } else {
                fatalError("Day not supported on older os versions. iOS >= 16.0 or macOS >= 13.0 needed")
            }
        case 6:
            return try Day6(testInput: testInput)
        case 7:
            return try Day7(testInput: testInput)
        case 8:
            return try Day8(testInput: testInput)
        default: throw DayError.notImplemented
        }
    }
}
