//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 04.12.22.
//
import Foundation

#if canImport(RegexBuilder)
import RegexBuilder

@available(iOS 16.0, macOS 13.0, *)
class Day4: Day {
    let input: [(Int, Int, Int, Int)]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "A Y\nB X\nC Z"
        } else {
            inputString = try InputGetter.getInput(for: 4, part: .first)
        }

        let regex = Regex {
            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            "-"
            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }

            ","

            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            "-"
            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
        }

        let input = inputString
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .compactMap { text -> (Int, Int, Int, Int)? in
                guard let result = text.wholeMatch(of: regex) else {
                    return nil
                }
                return (result.1, result.2, result.3, result.4)
            }

        self.input = input
    }

    func runPart1() throws {
        let result = input
            .filter {
                $0.0 <= $0.2 && $0.1 >= $0.3 || $0.2 <= $0.0 && $0.3 >= $0.1
            }
        print(result.count)
    }

    func runPart2() throws {
        let result = input
            .filter {
                ($0.0...$0.1).overlaps($0.2...$0.3)
            }
        print(result.count)
    }
}
#else
class Day4: Day {
    var day: Int { 4 }

    private let testInput: Bool

    init(testInput: Bool) throws {
        fatalError("can't use new Regex Builder on current platform")
    }

    func runPart1() throws {}

    func runPart2() throws {}
}
#endif
