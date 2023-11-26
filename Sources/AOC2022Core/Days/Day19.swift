//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 19.12.22.
//

import Foundation
import Algorithms

class Day19: Day {
    var day: Int { 19 }
    let input: [[Element: [Element: Int]]]

    let truthTable: [[Character]] = {
        var result: [[Character]] = []
        for i in 0..<(2 << (Element.allCases.count - 2)) {
            let bitsString = String(i, radix: 2)
            let leadingZeros = (Element.allCases.count - 1) - bitsString.count
            let bits = String(repeating: "0", count: leadingZeros).appending(bitsString).map { $0 }
            result.append(bits)
        }
        return result
    }()

    let sortedElements = Element.allCases.sorted { $0.value > $1.value }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.\n Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."
        } else {
            inputString = try InputGetter.getInput(for: 19, part: .first)
        }

        var input: [[Element: [Element: Int]]] = []
        for row in inputString.split(separator: "\n") where !row.isEmpty {
            var blueprint: [Element: [Element: Int]] = [:]
            let splitByDots = row.drop { $0 != ":" }.split(separator: ".")
            for robot in splitByDots {
                var items: [Element: Int] = [:]
                let splitByWhitespace = robot.dropFirst().split(separator: " ").filter { Int($0) != nil || Element(rawValue: $0) != nil }
                let currentRobot = Element(rawValue: splitByWhitespace[0])!
                var index = 1
                while index < splitByWhitespace.count {
                    let item = Element(rawValue: splitByWhitespace[index + 1])!
                    let amount = Int(splitByWhitespace[index])!
                    items[item] = amount
                    index += 2
                }

                blueprint[currentRobot] = items
            }
            input.append(blueprint)
        }

        self.input = input
    }

    func runPart1() async throws {
        let startAsync = CFAbsoluteTimeGetCurrent()
        let bestForEachBlueprint = await getBestAsync(availableTime: 24, startRobots: [.ore: 1], elements: [:], reducedList: false)
        let endAsync = CFAbsoluteTimeGetCurrent()

        let startSync = CFAbsoluteTimeGetCurrent()
        let bestForEachBlueprintSync = getBest(availableTime: 24, startRobots: [.ore: 1], elements: [:], reducedList: false)
        let endSync = CFAbsoluteTimeGetCurrent()

        let result = bestForEachBlueprint.enumerated().reduce(0) { $0 + ($1.offset + 1) * $1.element }
        print(result)

        print("async: \(endAsync - startAsync), sync: \(endSync - startSync), diff: \((endSync - startSync) - (endAsync - startAsync))")
    }

    func runPart2() async throws {
        let startAsync = CFAbsoluteTimeGetCurrent()
        let bestForEachBlueprint = await getBestAsync(availableTime: 32, startRobots: [.ore: 1], elements: [:], reducedList: true)
        let endAsync = CFAbsoluteTimeGetCurrent()

        let startSync = CFAbsoluteTimeGetCurrent()
        let bestForEachBlueprintSync = getBest(availableTime: 32, startRobots: [.ore: 1], elements: [:], reducedList: true)
        let endSync = CFAbsoluteTimeGetCurrent()

        let result = bestForEachBlueprint.reduce(1, *)
        print(result)

        print("async: \(endAsync - startAsync), sync: \(endSync - startSync), diff: \((endSync - startSync) - (endAsync - startAsync))")
    }

    func getBest(availableTime: Int, startRobots: [Element: Int], elements: [Element: Int], reducedList: Bool = false) -> [Int] {
        let toUse = reducedList ? Array(input.prefix(3)) : input

        let result = toUse
            .enumerated()
            .map { getBestBFS(for: $0.offset, availableTime: availableTime, startRobots: startRobots, elements: elements)}

        return result
    }

    func getBestAsync(availableTime: Int, startRobots: [Element: Int], elements: [Element: Int], reducedList: Bool = false) async -> [Int] {
        let toUse = reducedList ? Array(input.prefix(3)) : input

        let result = await withTaskGroup(of: (Int, Int).self, body: { [unowned self] group in
            for input in toUse.enumerated() {
                group.addTask { await (input.offset, self.getBestBFS(for: input.offset, availableTime: availableTime, startRobots: startRobots, elements: elements)) }
            }

            return await group.reduce(into: [:]) { dict, result in
                dict[result.0] = result.1
            }
        })

        return result.sorted { $0.key < $1.key}.map(\.value)
    }

    struct State: Hashable {
        let ore: Int
        let clay: Int
        let obsidian: Int
        let geode: Int
        let botOre: Int
        let botClay: Int
        let botObsidian: Int
        let botGeode: Int

        func copying(ore: Int? = nil, clay: Int? = nil, obsidian: Int? = nil, geode: Int? = nil, botOre: Int? = nil, botClay: Int? = nil, botObsidian: Int? = nil, botGeode: Int? = nil) -> State {
            .init(ore: ore ?? self.ore, clay: clay ?? self.clay, obsidian: obsidian ?? self.ore, geode: geode ?? self.geode, botOre: botOre ?? self.botOre, botClay: botClay ?? self.botClay, botObsidian: botObsidian ?? self.botObsidian, botGeode: botGeode ?? self.botGeode)
        }
    }

    func getBestBFS(for blueprint: Int, availableTime: Int, startRobots: [Element: Int], elements: [Element: Int]) -> Int {
        var states: Set<State> = [.init(ore: 0, clay: 0, obsidian: 0, geode: 0, botOre: 1, botClay: 0, botObsidian: 0, botGeode: 0)]

        let maxCost: [Element: Int] = .init(uniqueKeysWithValues: sortedElements.map { element in
            (element, input[blueprint].reduce(0) { max($0, $1.value[element] ?? 0) })
        })

        var maxPossible = 0
        var newStates: Set<State> = []
        var maxGeode = 0
        var maxGeodeBot = 0

        for step in 0..<availableTime {
            newStates = []
            if step % 4 == 0 {
                print("running \(step) for", blueprint)
            }

            for state in states where state.botGeode + 2 >= maxGeodeBot {
                let newOre = state.ore + state.botOre
                let newClay = state.clay + state.botClay
                let newObsidian = state.obsidian + state.botObsidian
                let newGeode = state.geode + state.botGeode

                maxGeode = max(maxGeode, newGeode)
                maxGeodeBot = max(maxGeodeBot, state.botGeode)

                maxPossible = max(newGeode + state.botGeode*(availableTime-1-step), maxPossible)

                newStates.insert(state.copying(ore: newOre, clay: newClay, obsidian: newObsidian, geode: newGeode))

                if state.obsidian >= input[blueprint][.geode]![.obsidian]!
                    && state.ore >= input[blueprint][.geode]![.ore]! {
                    newStates.insert(state.copying(ore: newOre - input[blueprint][.geode]![.ore]!,
                                                   clay: newClay,
                                                   obsidian: newObsidian - input[blueprint][.geode]![.obsidian]!,
                                                   geode: newGeode,
                                                   botGeode: state.botGeode + 1))
                    maxGeodeBot = max(maxGeodeBot, state.botGeode + 1)
                    continue
                }
                // buy ore
                if state.ore >= input[blueprint][.ore]![.ore]!
                    && state.botOre <= maxCost[.ore]! {
                    newStates.insert(state.copying(ore: newOre - input[blueprint][.ore]![.ore]!,
                                                   clay: newClay,
                                                   obsidian: newObsidian,
                                                   geode: newGeode,
                                                   botOre: state.botOre + 1))
                }
                // buy clay
                if state.ore >= input[blueprint][.clay]![.ore]!
                    && state.botClay <= maxCost[.clay]! {
                    newStates.insert(state.copying(ore: newOre - input[blueprint][.clay]![.ore]!,
                                                   clay: newClay,
                                                   obsidian: newObsidian,
                                                   geode: newGeode,
                                                   botClay: state.botClay + 1))
                }
                // buy obsidian
                if state.clay >= input[blueprint][.obsidian]![.clay]!
                    && state.ore >= input[blueprint][.obsidian]![.ore]!
                    && state.botObsidian <= maxCost[.obsidian]! {
                    newStates.insert(state.copying(ore: newOre - input[blueprint][.obsidian]![.ore]!,
                                                   clay: newClay - input[blueprint][.obsidian]![.clay]!,
                                                   obsidian: newObsidian,
                                                   geode: newGeode,
                                                   botObsidian: state.botObsidian + 1))
                }
            }
            states = newStates.filter {
                $0.geode + $0.botGeode * 2 * (availableTime - 1 - step) >= maxPossible
            }
        }
        return maxGeode
    }
}

enum Element: String, CaseIterable {
    case ore, clay, obsidian, geode

    init?(rawValue: Substring) {
        self.init(rawValue: String(rawValue))
    }

    init?(from index: Int) {
        switch index {
        case 0: self = .ore
        case 1: self = .clay
        case 2: self = .obsidian
        case 3: self = .geode
        default: return nil
        }
    }

    var value: Int {
        switch self {
        case .ore: return 1
        case .clay: return 2
        case .obsidian: return 3
        case .geode: return 4
        }
    }
}

extension Element: CustomStringConvertible {
    var description: String {
        self.rawValue
    }
}
