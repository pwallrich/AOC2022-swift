//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 07.12.22.
//

import Foundation

class Day7: Day {
    var day: Int { 7 }
    let input: [String]

    var directory: Directory?

    var fileSystem: [Directory] = []

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""
        } else {
            inputString = try InputGetter.getInput(for: 7, part: .first)
        }

        self.input = inputString
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }

        self.directory = parseDirectory(name: "/")
    }

    func runPart1() throws {
        let result = fileSystem
            .filter { $0.size <= 100000 }
            .map { $0.size }
            .reduce(0, +)

        print(result)
    }

    func runPart2() throws {
        guard let directory else {
            fatalError("no root found")
        }
        let unused = 70000000 - directory.size
        let result = fileSystem
            .sorted { $0.size < $1.size }
            .first(where: { $0.size + unused  >= 30000000 })

        let result2 = fileSystem
            .filter { $0.size + unused >= 30000000 }
            .map(\.size)
//            .sorted { $0.size < $1.size }
//            .first(where: { $0.size + unused  >= 30000000 })

        print(result2)

        print(result?.size)
    }

    func parseDirectory(startingAtIdx: Int = 1, name: String) -> Directory? {
        var dirs: [Directory] = []

        for line in input {
            let command = line.split(separator: " ")
            if command[0] == "$" && command[1] == "cd" {
                if command[2] == ".." {
                    // going up the tree
                    guard let dir = dirs.popLast() else {
                        fatalError("invalid input")
                    }
                    dirs[dirs.endIndex - 1].add(child: dir)
                    fileSystem.append(dir)
                } else {
                    // new dir
                    let dir = Directory(children: [], name: String(command[2]))
                    dirs.append(dir)
                }
            } else if let value = Double(command[0]) {
                // new file
                let file = File(size: value, name: String(command[1]))
                dirs[dirs.endIndex - 1].add(child: file)
            }
        }

        // go through all not terminated directories
        guard var current = dirs.popLast() else {
            fatalError("no root input found")
        }
        fileSystem.append(current)
        while !dirs.isEmpty {
            guard var next = dirs.popLast() else {
                break
            }
            next.add(child: current)
            current = next
            fileSystem.append(current)
        }

        return current
    }
}

protocol FilesystemItem {
    var size: Double { get }
    var name: String { get }
}

struct Directory: FilesystemItem {
    private(set) var children: [FilesystemItem]
    let name: String

    private(set) var size: Double = 0

    mutating func add(child: FilesystemItem) {
        children.append(child)
        size += child.size
    }
}

struct File: FilesystemItem {
    let size: Double
    let name: String
}
