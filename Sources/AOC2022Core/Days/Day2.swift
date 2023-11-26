//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 02.12.22.
//

import Foundation

class Day2: Day {
    var day: Int { 2 }
    let input: [String]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "A Y\nB X\nC Z"
        } else {
            inputString = try InputGetter.getInput(for: 2, part: .first)
        }
        
        let input = inputString
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }

        self.input = input
    }

    func runPart1() throws {
        let scores = input
            .map { $0.split(separator: " ").map { Move.getFrom(input: String($0)) } }
            .map { values in
                let them = values[0]
                let you = values[1]
                switch (you, them) {
                case (.rock, .rock), (.scissor, .scissor), (.paper, .paper):
                    return you.rawValue + 3
                case (.rock, .scissor), (.paper, .rock), (.scissor, .paper):
                    return you.rawValue + 6
                default:
                    return you.rawValue
                }
            }

        print(scores.reduce(0, +))
    }

    func runPart2() throws {
        let scores = input
            .map { input -> (Move, String) in
                let values = input.split(separator: " ")
                return (Move.getFrom(input: String(values[0])), String(values[1]))
            }
            .map { values in
                let them = values.0
                let you = values.1

                switch (them, you) {
                    // draw
                case (_, "Y"):
                    return them.rawValue + 3
                    // win
                case (.rock, "Z"):
                    return Move.paper.rawValue + 6
                case (.scissor, "Z"):
                    return Move.rock.rawValue + 6
                case (.paper, "Z"):
                    return Move.scissor.rawValue + 6
                    // lose
                case (.rock, "X"):
                    return Move.scissor.rawValue
                case (.scissor, "X"):
                    return Move.paper.rawValue
                case (.paper, "X"):
                    return Move.rock.rawValue
                default:
                    fatalError()
                }

            }

        print(scores)

        print(scores.reduce(0, +))
    }
}

private enum Move: Int {
    case rock = 1, paper = 2, scissor = 3

    static func getFrom(input: String) -> Move {
        switch input {
        case "A", "X": return .rock
        case "B", "Y": return .paper
        case "C", "Z": return .scissor
        default: fatalError()
        }
    }
}
