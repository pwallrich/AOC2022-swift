//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 05.12.22.
//

import Foundation

#if canImport(RegexBuilder)
import RegexBuilder
@available(iOS 16.0, *)
class Day5: Day {
    var day: Int { 5 }
    let input: [ArraySlice<String>]

    let moveRegex = Regex {
        "move "
        TryCapture {
            OneOrMore(.digit)
        } transform: {
            Int($0)
        }
        " from "
        TryCapture {
            OneOrMore(.digit)
        } transform: {
            Int($0)
        }
        " to "

        TryCapture {
            OneOrMore(.digit)
        } transform: {
            Int($0)
        }
    }

    init(testInput: Bool) throws {
        
        let inputString: String

        if testInput {
            inputString = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""
        } else {
            inputString = try InputGetter.getInput(for: 5, part: .first)
        }

        let input = inputString
            .components(separatedBy: "\n")
            .split(separator: "")
            .filter { !$0.isEmpty }

        self.input = input
    }

    func runPart1() throws {
        var stacks: [Int: String] = [:]

        for (index, character) in (input[0].last ?? "").enumerated() {
            guard let stack = character.wholeNumberValue else { continue }
            var resultString = ""
            for row in input[0].reversed().dropFirst() {
                guard index < row.count else { continue }
                let charIndex = row.index(row.startIndex, offsetBy: index)
                let nextCrate = row[charIndex]
                guard !nextCrate.isWhitespace else { continue }
                resultString.append(nextCrate)
            }
            stacks[stack] = resultString
        }

        print("starting moves on \(stacks)")

        for move in input[1] {
            guard let result = move.wholeMatch(of: moveRegex) else {
                print("couldn't match move: \(move)")
                continue
            }
            for _ in 1...result.1 {
                let removedCrate = stacks[result.2]?.popLast() ?? Character("")
                stacks[result.3]?.append(removedCrate)
            }
            print("After performing \(move)")
            print(stacks)
        }

        let result = stacks
            .sorted { $0.key < $1.key }
            .reduce("") { $0 + "\(($1.value.last ?? Character("")))" }

        print(result)
    }

    func runPart2() throws {
        var stacks: [Int: String] = [:]

        for (index, character) in (input[0].last ?? "").enumerated() {
            guard let stack = character.wholeNumberValue else { continue }
            var resultString = ""
            for row in input[0].reversed().dropFirst() {
                guard index < row.count else { continue }
                let charIndex = row.index(row.startIndex, offsetBy: index)
                let nextCrate = row[charIndex]
                guard !nextCrate.isWhitespace else { continue }
                resultString.append(nextCrate)
            }
            stacks[stack] = resultString
        }

        print("starting moves on \(stacks)")

        for move in input[1] {
            guard let result = move.wholeMatch(of: moveRegex) else {
                print("couldn't match move: \(move)")
                continue
            }
            var toRemoveFrom = stacks[result.2] ?? ""
            let splitIndex = toRemoveFrom.index(toRemoveFrom.endIndex, offsetBy: -result.1)
            let newValue = toRemoveFrom[splitIndex...]
            toRemoveFrom = String(toRemoveFrom[..<splitIndex])

            stacks[result.2] = toRemoveFrom

            stacks[result.3, default: ""] += String(newValue)

            print("After performing \(move)")
            print(stacks)
        }

        let result = stacks
            .sorted { $0.key < $1.key }
            .reduce("") { $0 + "\(($1.value.last ?? Character("")))" }

        print(result)
    }
}
#else
class Day5: Day {
    var day: Int { 5 }

    private let testInput: Bool

    init(testInput: Bool) throws {
        fatalError("can't use new Regex Builder on current platform")
    }

    func runPart1() throws {}

    func runPart2() throws {}
}
#endif
