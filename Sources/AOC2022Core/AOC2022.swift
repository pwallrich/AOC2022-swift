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

    public func run(day: Int, part: Part) async throws {
        let day = try getDay(day)

        switch part {
        case .first:
            try await day.runPart1()
        case .second:
            try await day.runPart2()
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
        case 9:
            return try Day9(testInput: testInput)
        case 10:
            return try Day10(testInput: testInput)
        case 11:
            return try Day11(testInput: testInput)
        case 12:
            return try Day12(testInput: testInput)
        case 13:
            return try Day13(testInput: testInput)
        case 14:
            return try Day14(testInput: testInput)
        case 15:
            return try Day15(testInput: testInput)
        case 16:
            return try Day16(testInput: testInput)
        case 17:
            return try Day17(testInput: testInput)
        case 18:
            return try Day18(testInput: testInput)
        case 19:
            return try Day19(testInput: testInput)
        case 20:
            return try Day20(testInput: testInput)
        case 21:
            return try Day21(testInput: testInput)
        case 22:
            return try Day22(testInput: testInput)
        case 23:
            return try Day23(testInput: testInput)
        case 24:
            return try Day24(testInput: testInput)
        case 25:
            return try Day25(testInput: testInput)
        default: throw DayError.notImplemented
        }
    }
}
