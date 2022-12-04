//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 03.12.22.
//

import Foundation

class Day3: Day {
    var day: Int { 3 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw"
        } else {
            inputString = try InputGetter.getInput(for: 3, part: .first)
        }

        let input = inputString
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }

        self.input = input
    }

    func runPart1() throws {
        let result = input
            .map { rucksack in
                let split = rucksack.count / 2
                let splitIndex = rucksack.index(rucksack.startIndex, offsetBy: split)
                let first = rucksack[..<splitIndex]
                let second = rucksack[splitIndex...]
                return (first, second)
            }
            .map { (Set($0.0), Set($0.1)) }
            .compactMap { $0.0.intersection($0.1).first }
            .map { return getPriority(of: $0) }
            .reduce(0, +)

        print(result)
    }

    func runPart2() throws {
        let result = stride(from: 0, to: input.count, by: 3)
            .map { input[$0 ..< min($0 + 3, input.count)]}
            .map { $0.map { Set($0) } }
            .map {
                $0.reduce(nil) { old, new in
                    (old?.intersection(new)) ?? new
                }
            }
            .compactMap { $0?.first }
            .map { getPriority(of: $0) }
            .reduce(0, +)

        print(result)

    }

    func getPriority(of char: Character) -> Int {
        let value = char.asciiValue!
        let res: UInt8
        if char.isUppercase {
            res = value - Character("A").asciiValue! + 27
        } else {
            res = value - Character("a").asciiValue! + 1
        }
        return Int(res)
    }
}
