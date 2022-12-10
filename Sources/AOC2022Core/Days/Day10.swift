//
//  File.swift
//
//
//  Created by Philipp Wallrich on 01.12.22.
//

import Foundation

class Day10: Day {
    var day: Int { 10 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = testInputString
        } else {
            inputString = try InputGetter.getInput(for: 10, part: .first)
        }

        self.input = inputString
    }

    func runPart1() throws {
        let result = runCommands(startValue: 1, checkValuesAt: [20, 60, 100, 140, 180, 220])
        print("result is \(result)")
    }

    func runPart2() throws {
    }

    func runCommands(startValue: Int, checkValuesAt steps: [Int]) -> Int {
        var steps = steps.sorted(by: >)
        guard var nextLimit = steps.popLast() else {
            return startValue
        }
        var result = 0
        var register = startValue
        var currentStep = 0

        print("starting: first limit: \(nextLimit)\n")

        for line in input.split(separator: "\n") where !line.isEmpty {
            var nextRegister = register
            if let value = getValueFrom(line: line) {
                // addx
                nextRegister = register + value
                currentStep = currentStep + 2
            } else {
                // noop
                currentStep = currentStep + 1
            }

            switch currentStep {
            case nextLimit + 1, nextLimit + 2, nextLimit:
                result += nextLimit * register
                print("checkin during step: ", nextLimit, register, nextRegister, currentStep, nextLimit * register,  result)
            default:
                break
            }

            register = nextRegister

            if currentStep >= nextLimit {
                guard let next = steps.popLast() else {
                    return result
                }
                nextLimit = next
            }

        }
        if !steps.isEmpty {
            fatalError("only executed \(currentStep) iterations")
        }
        return result
    }

    func getValueFrom(line: String.SubSequence) -> Int? {
        guard let lastPart = line.split(separator: " ").last,
              let value = Int(lastPart)
        else {
            return nil
        }
        return value
    }
}

fileprivate let testInputString: String = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""
