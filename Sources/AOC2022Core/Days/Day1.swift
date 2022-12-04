//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 01.12.22.
//

import Foundation

class Day1: Day {
    var day: Int { 1 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"
        } else {
            inputString = try InputGetter.getInput(for: 1, part: .first)
        }

        self.input = inputString
            .components(separatedBy: "\n")
            .split(separator: "")
            .map { $0.compactMap { Int($0) }}
            .map { $0.reduce(0, +) }
            .sorted(by: >)
    }

    func runPart1() throws {
        print("result is \(input.first)")
    }

    func runPart2() throws {
        guard input.count >= 3 else {
            fatalError("Not enough items found")
        }
        let result = input[..<3].reduce(0, +)
        print("result is \(result)")
    }
}
