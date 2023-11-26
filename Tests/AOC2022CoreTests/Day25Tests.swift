//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 25.12.22.
//

import Foundation

import XCTest
@testable import AOC2022Core

final class Day25Tests: XCTestCase {

    var sut: Day25!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = try .init(testInput: true)
    }

    func testSnafuToDec() {
        let dec = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 2022, 12345, 314159265]
        let snafu = ["1", "2", "1=", "1-", "10", "11", "12", "2=", "2-", "20", "1=0", "1-0", "1=11-2", "1-0---0", "1121-1110-1=0"]

        let result = snafu.map { sut.convertSnafuToDec(snafu: $0) }

        for (res, exp) in zip(result, dec) {
            XCTAssertEqual(res, exp)
        }
    }

    func testDecToSnafu() {
        let dec = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 2022, 12345, 314159265]
        let snafu = ["1", "2", "1=", "1-", "10", "11", "12", "2=", "2-", "20", "1=0", "1-0", "1=11-2", "1-0---0", "1121-1110-1=0"]

        let result = dec.map { sut.convertDecToSnafo(dec: $0) }

        for (res, exp) in zip(result, snafu) {
            XCTAssertEqual(res, exp)
        }
    }

}
