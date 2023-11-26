//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 20.12.22.
//

import Foundation

class Day20: Day {
    var day: Int { 20 }
    let input: [Item]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1\n2\n-3\n3\n-2\n0\n4"
        } else {
            inputString = try InputGetter.getInput(for: 20, part: .first)
        }

        self.input = inputString
            .split(separator: "\n")
            .map { Item(value: Int($0)!) }
    }

    func runPart1() throws {
        mix()
    }

    func runPart2() throws {
        mix(rounds: 10, multiplyBy: 811589153)
    }

    func mix(rounds: Int = 1, multiplyBy: Int = 1) {
        // store at which index everything is
        let original = input.map { Item(value: $0.value * multiplyBy) }
        var newList = original
        print(input.count)

        for round in 1...rounds {
            print("Round: \(round)")
            for value in original {
                let currentIndex = newList.firstIndex { $0 === value }!
                newList.remove(at: currentIndex)

                var newIndex = (currentIndex + value.value) % newList.count

                if newIndex < 0 {
                    newIndex = newList.index(newList.endIndex, offsetBy: newIndex)
                }
                newList.insert(value, at: newIndex)
            }
        }

        let idx = newList.firstIndex { $0.value == 0 }!

        let a = (idx + 1000) % input.count
        let b = (idx + 2000) % input.count
        let c = (idx + 3000) % input.count
        print(newList[a].value, newList[b].value, newList[c].value)
        print(newList[a].value + newList[b].value + newList[c].value)
    }
}

class Item {
    let value: Int

    init(value: Int) {
        self.value = value
    }
}

extension Item: CustomStringConvertible {
    var description: String {
        "\(value)"
    }
}
