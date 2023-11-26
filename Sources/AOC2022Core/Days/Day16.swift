//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 16.12.22.
//

import Foundation
import Algorithms

class Day16: Day {
    var day: Int { 16 }
    let input: [String: (rate: Int, destinations: [String])]
    let filtered: [Int]
    var timeAllowed: Int!

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = testInputString
        } else {
            inputString = try InputGetter.getInput(for: 16, part: .first)
        }

        var items: [String: (rate: Int, destinations: [String])] = [:]
        for row in inputString.split(separator: "\n") where !row.isEmpty {
            let byWhitespace = row.split(separator: " ")

            let name = byWhitespace[1]
            let flowStartIndex = byWhitespace[4].firstIndex(of: "=")!
            let flowEndIndex = byWhitespace[4].firstIndex(of: ";")!
            let flow = Int(byWhitespace[4][byWhitespace[4].index(after: flowStartIndex)..<flowEndIndex])!
            let destinations = byWhitespace[9...].map { $0.filter { $0 != "," } }

//            print(name, flow, destinations)
            items[String(name)] = (flow, destinations.map { String($0) })
        }
        self.input = items

        filtered = items.map(\.value.rate).filter { $0 > 0}

        print(filtered.count)
    }

    func runPart1() throws {
        timeAllowed = 30
        best2()
        dfs(currScore: 0, currValve: "AA", opened: [], time: 0, firstPlayer: false)
        print(score)
    }

    func runPart2() throws {
        timeAllowed = 26
        best2()
        dfs(currScore: 0, currValve: "AA", opened: [], time: 0, firstPlayer: true)

        print(score)
    }

    struct CacheKey: Hashable {
        let start: String
        let remaining: Int
        let openend: Set<String>
    }

    func bestMoves(startPoint: String, remainingTime: Int, opened: Set<String> = [], currentRate: Int) -> ([Action], Int)? {
        // if current Time is last second
        guard remainingTime > 1 else { return ([], currentRate) }

        let (rate, destinations) = input[startPoint]!

        var best: ([Action], Int)?
        // check case for not yet opened valve
        if !opened.contains(startPoint) && rate > 0 {
            var newOpened = opened
            newOpened.insert(startPoint)
            if let cached = cache[.init(start: startPoint, remaining: remainingTime - 1, openend: newOpened)] {
                best = ([.open(startPoint)] + cached.0, cached.1 + currentRate)
            } else if let result = bestMoves(startPoint: startPoint, remainingTime: remainingTime - 1, opened: newOpened, currentRate: currentRate + rate) {
                best = ([.open(startPoint)] + result.0, result.1 + currentRate)
            }
        }

        for destination in destinations {
            var current: ([Action], Int)?
            if let cached = cache[.init(start: destination, remaining: remainingTime - 1, openend: opened)] {
                current = cached
            } else if let result = bestMoves(startPoint: destination, remainingTime: remainingTime - 1, opened: opened, currentRate: currentRate) {
                current = result
            }
            guard let current = current else { continue }
            if current.1 + currentRate > (best?.1 ?? -1) {
                best = ([.move(destination)] + current.0, current.1 + currentRate)
            }
        }
        if let best = best {
            cache[.init(start: startPoint, remaining: remainingTime, openend: opened)] = best
        }

        return best
    }

    func best2() {
        var distances: [String: [String: Int]] = [:]
        for valve in input {
            for neighbor in valve.value.destinations {
                distances[valve.key, default: [:]][neighbor] = 1
            }
        }

        floydWarshall(distances: &distances)

//        print(distances)

        self.distances = distances
    }

    var score = 0
    var distances: [String: [String: Int]]!

    func dfs(currScore: Int, currValve: String, opened: Set<String>, time: Int, firstPlayer: Bool) {
//        print(currScore, currValve, opened, time, firstPlayer, score)
        score = max(score, currScore)
        for (valve, dist) in distances[currValve]! {
            if !opened.contains(valve) && time + dist + 1 < timeAllowed && input[valve]!.rate != 0 {
                dfs(currScore: currScore + (timeAllowed - time - dist - 1) * input[valve]!.rate,
                    currValve: valve,
                    opened: opened.union([valve]),
                    time: time + dist + 1,
                    firstPlayer: firstPlayer)
            }
        }
        if firstPlayer {
            dfs(currScore: currScore, currValve: "AA", opened: opened, time: 0, firstPlayer: false)
        }
    }

    func floydWarshall(distances: inout [String: [String: Int]]){
        for k in distances.keys {
            for i in distances.keys {
                for j in distances.keys {
                    let ik = distances[i]![k] ?? 9999
                    let kj = distances[k]![j] ?? 9999
                    let ij = distances[i]![j] ?? 9999
                    if (ik + kj < ij) {
                        distances[i]![j] = ik + kj
                    }
                }
            }
        }

        for distance in distances {
            distances[distance.key] = distance.value.filter { input[$0.key]!.rate != 0 }
        }
    }

    struct CacheKey2: Hashable {
        let start: Set<String>
        let remaining: Int
        let openend: Set<String>
    }

    var cache: [CacheKey: ([Action], Int)] = [:]
    var cache2: [CacheKey2: Int] = [:]
}

class Pipe {
    let name: String
    let outFlow: Int
    var isOpen: Bool
    var children: [Pipe]

    init(name: String, outFlow: Int) {
        self.name = name
        self.outFlow = outFlow
        self.isOpen = false
        self.children = []
    }

    var values: [Set<String>: Int] = [:]
}

extension Pipe: CustomStringConvertible {
    var description: String {
        "(\(name), \(outFlow)) => \(children.map(\.name).joined(separator: ","))"
    }
}

extension Pipe {
    func maximumOutflow(in minutes: Int, opened: Set<String> = []) -> Int {
        if !opened.contains(name) {
            // open and see what happens
            var opened = opened
            opened.insert(name)
            return outFlow * (minutes - 1)
        }
        return 0
    }
}

enum Action: Equatable {
    case open(String), move(String)
}

extension Action: CustomStringConvertible {
    var description: String {
        switch self {
        case let .open(value): return "O: \(value)"
        case let .move(value): return "M: \(value)"
        }
    }
}

fileprivate let testInputString = """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""
