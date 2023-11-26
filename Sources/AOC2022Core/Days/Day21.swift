//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 21.12.22.
//

import Foundation

class Day21: Day {
    var day: Int { 21 }
    let input: [String: MonkeyAction]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = testInputString
        } else {
            inputString = try InputGetter.getInput(for: 21, part: .first)
        }

        var map: [String: MonkeyAction] = [:]
        for row in inputString.split(separator: "\n") {
            let split = row.split(separator: ":")
            let key = split[0]
            let action: MonkeyAction
            if let number = Double(split[1].trimmingCharacters(in: .whitespaces)) {
                action = .number(number)
            } else {
                action = .action(String(split[1].trimmingCharacters(in: .whitespaces)))
            }
            map[String(key)] = action
        }

        self.input = map

    }

    func runPart1() throws {
        print(eval(at: "root", input: input))
    }

    func runPart2() async throws {
        let formula = eval2(at: "root")
        guard case let .formula(lhs, _, rhs) = formula else { fatalError() }

        let (withHumn, numbersOnly) = lhs.containsHumn ? (lhs, rhs) : (rhs, lhs)
        let number = solve(numbersOnly)
        print(withHumn)
        print(number)
        let value = solveForHumn(withHumn, initial: number, wasInitialLeft: lhs == numbersOnly)
        print(value)
    }

    func solveForHumn(_ formula: ReturnType, initial: Double, wasInitialLeft: Bool) -> Double {
        switch formula {
        case let .formula(lhs, op, rhs):
            let (numbersOnly, humn) = lhs.containsHumn ? (rhs, lhs) : (lhs, rhs)
            let number = solve(numbersOnly)
            var current: Double
            switch op {
            case "+":
                current = initial - number
            case "*":
                current = initial / number
            case "/":
                if rhs == numbersOnly {
                    current = initial * number
                } else {
                    current = 1 / (initial * number)
                }
            case "-":
                if rhs == numbersOnly {
                    current = initial + number
                } else {
                    current = -1 * (initial - number)
                }
            default:
                fatalError()
            }
            return solveForHumn(humn, initial: current, wasInitialLeft: numbersOnly == lhs)
        case let .number(number): return number
        case .humn:
            return initial
        }
    }

    func solve(_ formula: ReturnType) -> Double {
        switch formula {
        case let .formula(lhs, op, rhs):
            let n1 = solve(lhs)
            let n2 = solve(rhs)
            switch op {
            case "+":
                return n1 + n2
            case "*":
                return n1 * n2
            case "/":
                return n1 / n2
            case "-":
                return  n1 - n2
            default:
                fatalError()
            }
        case let .number(number): return number
        case .humn:
            fatalError()
        }
    }

    func eval2(at: String) -> ReturnType {
        guard at != "humn" else {
            return .humn
        }
        let action: String
        switch input[at] {
        case let .number(number):
            return .number(number)
        case let .action(a):
            action = a
        default:
            fatalError()
        }

        let split = action.split(separator: " ")

        let formula1 = eval2(at: String(split[0]))
        let formula2 = eval2(at: String(split[2]))

        return .formula(formula1, String(split[1]), formula2)
    }

    func evalRoot2(input: [String: MonkeyAction]) -> (Double, Double) {
        let action: String
        switch input["root"] {
        case let .action(a):
            action = a
        default:
            fatalError()
        }
        let split = action.split(separator: " ")

        let n1 = eval(at: String(split[0]), input: input)
        let n2 = eval(at: String(split[2]), input: input)
        return (n1, n2)
    }

    func eval(at: String, input: [String: MonkeyAction]) -> Double {
        let action: String
        switch input[at] {
        case let .number(number):
            return number
        case let .action(a):
            action = a
        default:
            fatalError()
        }

        let split = action.split(separator: " ")

        let n1 = eval(at: String(split[0]), input: input)
        let n2 = eval(at: String(split[2]), input: input)


        switch split[1] {
        case "+":
            return n1 + n2
        case "*":
            return n1 * n2
        case "/":
            return n1 / n2
        case "-":
            return  n1 - n2
        default:
            fatalError()
        }
    }

    indirect enum ReturnType: CustomStringConvertible, Equatable {
        case number(Double), formula(ReturnType, String, ReturnType), humn

        var containsHumn: Bool {
            switch self {
            case .number: return false
            case .humn: return true
            case let .formula(lhs, _, rhs): return lhs.containsHumn || rhs.containsHumn
            }
        }

        var description: String {
            switch self {
            case .humn: return "x"
            case let .formula(lhs, op, rhs): return "(\(lhs.description)\(op)\(rhs.description))"
            case let.number(number): return String(format: "%.0f", number)
            }
        }
    }
}

enum MonkeyAction {
    case number(Double), action(String)
}


fileprivate let testInputString = """
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
"""
