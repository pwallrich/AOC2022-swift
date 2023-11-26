//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 25.12.22.
//

import Foundation

class Day25: Day {
    var day: Int { 25 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1=-0-2\n12111\n2=0=\n21\n2=01\n111\n20012\n112\n1=-1=\n1-12\n12\n1=\n122"
        } else {
            inputString = try InputGetter.getInput(for: 25, part: .first)
        }

        self.input = inputString
            .components(separatedBy: "\n")
    }

    func runPart1() throws {
        let decimals = input
            .map(convertSnafuToDec(snafu:))

        let sum = decimals.reduce(0, +)

        let result = convertDecToSnafo(dec: sum)

        print(result)

    }

    func runPart2() throws {
    }

    func convertSnafuToDec(snafu: String) -> Int {
        var res = 0
        for (idx, char) in snafu.reversed().enumerated() {
            let powFifth = (0..<idx).reduce(1) { new, _ in new * 5 }
            if let value = Int(String(char)) {
                res += powFifth  * value
            } else if char == "-" {
                res -= powFifth
            } else if char == "=" {
                res -= 2 * powFifth
            }
        }
        return res
    }

    func convertDecToSnafo(dec: Int) -> String {
        var value = dec
        var res = ""
        var lastOverflow: Int = 0
        while value > 0 {
            let digit = value % 5 + lastOverflow
            if digit == 5 {
                res = "0" + res
                lastOverflow = 1
            } else if digit == 4 {
                lastOverflow = 1
                res = "-" + res
            } else if digit == 3 {
                lastOverflow = 1
                res = "=" + res
            } else {
                lastOverflow = 0
                res = "\(digit)" + res
            }
            value = value / 5
//            print(digit)
        }
        if lastOverflow != 0 {
            res = "\(lastOverflow)" + res
        }
        return res
    }
}
