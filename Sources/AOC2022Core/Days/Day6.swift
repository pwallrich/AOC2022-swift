//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 06.12.22.
//

import Foundation

class Day6: Day {
    var day: Int { 6 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "bvwbjplbgvbhsrlpgdmjqwftvncz\nnppdvjthqldpwncqszvftbrmjlhg\nnznrnfrfntjfmvfwmzdfjlvtqnbhcprsg\nzcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
        } else {
            inputString = try InputGetter.getInput(for: 6, part: .first)
        }

        self.input = inputString
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
    }

    func runPart1() throws {
        for row in input {
            guard let idx = row.getIndexAfterFirstDistinct(of: 4) else {
                print("no match found")
                continue
            }
            print("result is \(idx)")
        }
    }

    func runPart2() throws {
        for row in input {
            guard let idx = row.getIndexAfterFirstDistinct(of: 14) else {
                print("no match found")
                continue
            }
            print("result is \(idx)")
        }
    }
}

private extension String {
    func getIndexAfterFirstDistinct(of length: Int) -> Int? {
        // TODO: Check whether, windows of swift-algorithms make it cleaner
        for idx in 0...(count - length) {
            var chars: Set<Character> = []
            for i in 0..<length {
                let idx = index(startIndex, offsetBy: i + idx)
                guard !chars.contains(self[idx]) else {
                    break
                }
                chars.insert(self[idx])
            }
            if chars.count == length {
                return idx + length
            }
        }
        return nil
    }
}
