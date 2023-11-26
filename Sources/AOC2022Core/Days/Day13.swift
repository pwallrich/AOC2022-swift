//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 13.12.22.
//

import Foundation

class Day13: Day {
    var day: Int { 13 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "[1,1,3,1,1]\n[1,1,5,1,1]\n\n[[1],[2,3,4]]\n[[1],4]\n\n[9]\n[[8,7,6]]\n\n[[4,4],4,4]\n[[4,4],4,4,4]\n\n[7,7,7,7]\n[7,7,7]\n\n[]\n[3]\n\n[[[]]]\n[[]]\n\n[1,[2,[3,[4,[5,6,7]]]],8,9]\n[1,[2,[3,[4,[5,6,0]]]],8,9]"
        } else {
            inputString = try InputGetter.getInput(for: 13, part: .first)
        }

        self.input = inputString

    }

    func runPart1() throws {
        let parsed = parseInput()
        var correctIndices: [Int] = []

        for (idx, tuple) in parsed.enumerated() {
            if tuple.first < tuple.second {
                correctIndices.append(idx + 1)
            }
        }

        print(correctIndices.reduce(0, +))
    }

    func runPart2() throws {
        let parsed = parseInputPart2()

        let separator1 = MessageBlock.list([.list([.number(2)])])
        let separator2 = MessageBlock.list([.list([.number(6)])])

        let withSeparator = parsed + [separator1, separator2]
        let sorted = withSeparator.sorted(by: <)

        let firstIndex = sorted.firstIndex(of: separator1)
        let secondIndex = sorted.firstIndex(of: separator2)


        print((firstIndex! + 1) * (secondIndex! + 1))
    }

    func parseInput() -> [(first: MessageBlock, second: MessageBlock)] {
        var result: [(first: MessageBlock, second: MessageBlock)] = []

        for (pairs) in input.components(separatedBy: "\n\n") {
            let splitPair = pairs.split(separator: "\n")

            let first = splitPair[0]
            let second = splitPair[1]

            let firstBlock = first.parse(startingIndex: first.index(after: first.startIndex))
//            print(firstBlock)
//            print()
            let secondBlock = second.parse(startingIndex: second.index(after: second.startIndex))

//            print(secondBlock)
//            print()
            result.append((firstBlock.block, secondBlock.block))
        }

        return result
    }

    func parseInputPart2() -> [MessageBlock] {
        input
            .split(separator: "\n")
            .compactMap { (row: String.SubSequence) -> MessageBlock? in
                guard !row.isEmpty else { return nil }
                return row.parse(startingIndex: row.index(after: row.startIndex)).block
            }

//        print(test)
//            .compactMap { row -> MessageBlock? in
//                guard !row.isEmpty else { return nil }
//                return row.parse(startingIndex: row.index(after: row.startIndex))
//            }
    }
}

indirect enum MessageBlock {
    case list([MessageBlock])
    case number(Int)
}

extension MessageBlock: Comparable {
    static func < (lhs: MessageBlock, rhs: MessageBlock) -> Bool {
        switch Self.checkOrder(lhs, rhs) {
        case .equal, .rightBigger: return true
        default: return false
        }
    }

    static func checkOrder(_ first: MessageBlock, _ second: MessageBlock) -> Order {
        switch (first, second) {
        case let (.number(firstValue), .number(secondValue)) where firstValue == secondValue:
//            print("found equal numbers \(firstValue), \(secondValue)")
            return .equal
        case let (.number(firstValue), .number(secondValue)):
//            print("found unequal numbers \(firstValue), \(secondValue)")
            return firstValue > secondValue ? .leftBigger : .rightBigger
        case let (.list(firstList), .list(secondList)):
//            print("found lists \(firstList), \(secondList)")
            var idx = 0
            while firstList.count > idx && secondList.count > idx {
                let nextFirst = firstList[idx]
                let nextSecond = secondList[idx]
//                print("evaluating at: \(idx), nextFirst: \(nextFirst), nextSecond: \(nextSecond)")
                let order = checkOrder(nextFirst, nextSecond)
//                print("got list return: \(order)")
                if order != .equal {
                    return order
                }
                idx += 1
            }
            if firstList.count == secondList.count {
                return .equal
            }
            return firstList.count > secondList.count ? .leftBigger : .rightBigger
        case (.list, .number):
            return checkOrder(first, .list([second]))
        case (.number, .list):
            return checkOrder(.list([first]), second)
        }
    }

    enum Order {
        case leftBigger, equal, rightBigger
    }
}

extension MessageBlock: CustomStringConvertible {
    var description: String {
        var res = ""
        switch self {
        case let .number(value):
            res.append("\(value)")
        case let .list(blocks):
            res += "[" + blocks.map(\.description).joined(separator: ",") + "]"
        }
        return res
    }
}

extension String.SubSequence {
    func parse(startingIndex: Substring.Index) -> (block: MessageBlock, parsedUntil: Substring.Index)  {
        var current: [MessageBlock] = []
//        print("startingParse with \(distance(from: startIndex, to: startingIndex))")
        var idx = startingIndex

        while idx < endIndex {
            let char = self[idx]
//            print("evaluating: \(char) from \(distance(from: startIndex, to: idx))")
            if char == "[" {
                // start recursion
//                print("starting recursion")
                let (block, parsedUntil) = parse(startingIndex: index(idx, offsetBy: 1))
//                print("finished recursion \(block), \(distance(from: startIndex, to: parsedUntil))")
                current.append(block)
                idx = index(parsedUntil, offsetBy: 1)
            } else if char == "]" {
                // end recursion
//                print("finishing recursion \(distance(from: startIndex, to: idx)), \(current)")
                return (.list(current), idx)
            } else if char == "," {
                // store element
                idx = index(idx, offsetBy: 1)
//                print("got `,` newIndex: \(distance(from: startIndex, to: idx))")
            } else if char.isNumber {
                let nextIndex = self[idx...].firstIndex { $0 == "," || $0 == "]" }!
                let value = Int(self[idx..<nextIndex])!
//                print("gotNumber: from \(distance(from: startIndex, to: idx)) to \(distance(from: startIndex, to: nextIndex)), found: \(self[nextIndex]), value: \(value)")
                // start parsing number
                current.append(.number(value))
                idx = nextIndex
            }
        }

        return (.list(current), idx)
    }
}
