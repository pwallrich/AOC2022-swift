//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 11.12.22.
//

import Foundation

class Day11: Day {
    var day: Int { 11 }
    let input: [Monkey]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = testInputString
        } else {
            inputString = try InputGetter.getInput(for: 11, part: .first)
        }

        self.input = inputString
            .components(separatedBy: "\n\n")
            .map(Monkey.init(from:))
    }

    func runPart1() throws {
        var monkeys = input
        var counters = Array(repeating: 0, count: monkeys.count)
        for i in 0..<20 {
            for idx in 0..<monkeys.count {
//                print("Monkey: \(i)")
                let monkey = monkeys[idx]
                for item in monkey.items {
                    counters[idx] += 1
//                    print("\titem: \(item)")
                    let newValue = monkey.operation(item)
//                    print("\tnewValue: \(newValue)")
                    let reducedNewValue = (newValue / 3).rounded(.down)
//                    print("\treduced: \(reducedNewValue)")
                    if monkey.condition(reducedNewValue) {
//                        print("\tdivisible throwing to: \(monkey.throwToTrue)")
                        monkeys[monkey.throwToTrue].items.append(reducedNewValue)
                    } else {
//                        print("\tnot divisible throwing to: \(monkey.throwToFalse)")
                        monkeys[monkey.throwToFalse].items.append(reducedNewValue)
                    }
                    monkeys[idx].items = []
                }
//                print(monkeys.map(\.items))
            }
//            print(monkeys.map(\.items))
        }

//        print(monkeys.map(\.items))

        let sorted = counters
            .sorted(by: >)

        let result = sorted[0] * sorted[1]

        print("part1: \(result)")

//        for i in 0..<20 {
//
//        }
//        print(input)
    }

    func runPart2() throws {
        var monkeys = input
        let moduleToUse = monkeys.reduce(1) { $0 * $1.conditionValue}
        var counters = Array(repeating: 0, count: monkeys.count)
        for i in 0..<10000 {
            if [1, 20, 1000, 2000].contains(i) {
                print(counters)
            }
            for idx in 0..<monkeys.count {
                let monkey = monkeys[idx]
                for item in monkey.items {
                    counters[idx] += 1
                    let newValue = monkey.operation(item)
                    let reducedNewValue = newValue.truncatingRemainder(dividingBy: moduleToUse)
                    if monkey.condition(reducedNewValue) {
                        monkeys[monkey.throwToTrue].items.append(reducedNewValue)
                    } else {
                        monkeys[monkey.throwToFalse].items.append(reducedNewValue)
                    }
                    monkeys[idx].items = []
                }
            }

        }

        let sorted = counters
            .sorted(by: >)

        let result = sorted[0] * sorted[1]

        print("part2: \(result)")

//        for i in 0..<20 {
//
//        }
//        print(input)
    }
}

struct Monkey {
    var items: [Double]
    let operation: (Double) -> Double
    let condition: (Double) -> Bool
    let conditionValue: Double
    let throwToTrue: Int
    let throwToFalse: Int

    init(from: String) {
        let rows = from.split(separator: "\n")
        var items: [Double]?
        var operation: ((Double) -> Double)?
        var condition: ((Double) -> Bool)?
        var conditionValue: Double?
        var throwToTrue: Int?
        var throwToFalse: Int?

        var debugStr = ""

        for (idx, row) in rows.enumerated() {
            switch idx {
            case 1:
                items = row
                    .split(separator: ":")
                    .last!
                    .split(separator: ",")
                    .compactMap { Double($0.filter { !$0.isWhitespace }) }
                debugStr.append("\(items!)")
            case 2:
                let strIdx = row.lastIndex(of: " ")!

                if let value = Double(row[strIdx...].filter { !$0.isWhitespace }) {
                    switch row[row.index(strIdx, offsetBy: -1)] {
                    case "+":
                        operation = { $0 + value }
                        debugStr.append(" op: + \(value)")
                    case "*":
                        operation = { $0 * value }
                        debugStr.append(" op: * \(value)")
                    default:
                        break
                    }
                } else if row[strIdx...] == " old" {
                    switch row[row.index(strIdx, offsetBy: -1)] {
                    case "+":
                        operation = { $0 + $0 }
                        debugStr.append(" op: + self")
                    case "*":
                        operation = { $0 * $0 }
                        debugStr.append(" op: * self")
                    default:
                        break
                    }
                }
            case 3:
                let strIdx = row.lastIndex(of: " ")!
                let value = Double(row[strIdx...].filter { !$0.isWhitespace })!
                debugStr.append(" op: % \(value)")
                condition = { $0.truncatingRemainder(dividingBy: value) == 0 }
                conditionValue = value
            case 4:
                let strIdx = row.lastIndex(of: " ")!
                let value = Int(row[strIdx...].filter { !$0.isWhitespace })!

                throwToTrue = value
            case 5:
                let strIdx = row.lastIndex(of: " ")!
                let value = Int(row[strIdx...].filter { !$0.isWhitespace })!

                throwToFalse = value

            default:
                break
            }
        }
        self.items = items!
        self.operation = operation!
        self.condition = condition!
        self.throwToTrue = throwToTrue!
        self.throwToFalse = throwToFalse!
        self.conditionValue = conditionValue!
//        print(debugStr, throwToTrue!, throwToFalse!)
    }
}


fileprivate let testInputString = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""
