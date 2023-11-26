//
//  Day22Tests.swift
//  
//
//  Created by Philipp Wallrich on 22.12.22.
//

import XCTest
@testable import AOC2022Core

final class Day22Tests: XCTestCase {

    var sut: Day22!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = try .init(testInput: true)
    }

    func testArea1Right() {
        let start1 = Point(x: 11, y: 0)
        let res1 = sut.wrapAround(start: start1, direction: .right, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 15, y: 11))
        XCTAssertEqual(res1.1, .left)

        let start2 = Point(x: 11, y: 3)
        let res2 = sut.wrapAround(start: start2, direction: .right, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 15, y: 8))
        XCTAssertEqual(res2.1, .left)
    }

    func testArea1Down() {
        let start1 = Point(x: 8, y: 3)
        let res1 = sut.wrapAround(start: start1, direction: .down, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 4))
        XCTAssertEqual(res1.1, .down)

        let start2 = Point(x: 11, y: 3)
        let res2 = sut.wrapAround(start: start2, direction: .down, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 4))
        XCTAssertEqual(res2.1, .down)
    }

    func testArea1Left() {
        let start1 = Point(x: 8, y: 0)
        let res1 = sut.wrapAround(start: start1, direction: .left, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 4, y: 4))
        XCTAssertEqual(res1.1, .down)

        let start2 = Point(x: 8, y: 3)
        let res2 = sut.wrapAround(start: start2, direction: .left, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 7, y: 4))
        XCTAssertEqual(res2.1, .down)
    }

    func testArea1Up() {
        let start1 = Point(x: 8, y: 0)
        let res1 = sut.wrapAround(start: start1, direction: .up, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 3, y: 4))
        XCTAssertEqual(res1.1, .down)

        let start2 = Point(x: 11, y: 0)
        let res2 = sut.wrapAround(start: start2, direction: .up, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 0, y: 4))
        XCTAssertEqual(res2.1, .down)
    }

    func testArea2Right() {
        let start1 = Point(x: 3, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .right, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 4, y: 4))
        XCTAssertEqual(res1.1, .right)

        let start2 = Point(x: 3, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .right, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 4, y: 7))
        XCTAssertEqual(res2.1, .right)
    }

    func testArea2Down() {
        let start1 = Point(x: 0, y: 7)
        let res1 = sut.wrapAround(start: start1, direction: .down, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 11, y: 11))
        XCTAssertEqual(res1.1, .up)

        let start2 = Point(x: 3, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .down, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 8, y: 11))
        XCTAssertEqual(res2.1, .up)
    }

    func testArea2Left() {
        let start1 = Point(x: 0, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .left, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 15, y: 11))
        XCTAssertEqual(res1.1, .up)

        let start2 = Point(x: 0, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .left, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 12, y: 11))
        XCTAssertEqual(res2.1, .up)
    }

    func testArea2Up() {
        let start1 = Point(x: 0, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .up, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 11, y: 0))
        XCTAssertEqual(res1.1, .down)

        let start2 = Point(x: 3, y: 4)
        let res2 = sut.wrapAround(start: start2, direction: .up, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 8, y: 0))
        XCTAssertEqual(res2.1, .down)
    }

    func testArea3Right() {
        let start1 = Point(x: 7, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .right, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 4))
        XCTAssertEqual(res1.1, .right)

        let start2 = Point(x: 7, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .right, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 8, y: 7))
        XCTAssertEqual(res2.1, .right)
    }

    func testArea3Down() {
        let start1 = Point(x: 4, y: 7)
        let res1 = sut.wrapAround(start: start1, direction: .down, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 11))
        XCTAssertEqual(res1.1, .right)

        let start2 = Point(x: 7, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .down, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 8, y: 8))
        XCTAssertEqual(res2.1, .right)
    }

    func testArea3Left() {
        let start1 = Point(x: 4, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .left, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 3, y: 4))
        XCTAssertEqual(res1.1, .left)

        let start2 = Point(x: 4, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .left, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 3, y: 7))
        XCTAssertEqual(res2.1, .left)
    }

    func testArea3Up() {
        let start1 = Point(x: 4, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .up, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 0))
        XCTAssertEqual(res1.1, .right)

        let start2 = Point(x: 7, y: 4)
        let res2 = sut.wrapAround(start: start2, direction: .up, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 8, y: 3))
        XCTAssertEqual(res2.1, .right)
    }

    func testArea4Right() {
        let start1 = Point(x: 11, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .right, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 15, y: 8))
        XCTAssertEqual(res1.1, .down)

        let start2 = Point(x: 11, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .right, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 12, y: 8))
        XCTAssertEqual(res2.1, .down)
    }

    func testArea4Down() {
        let start1 = Point(x: 8, y: 7)
        let res1 = sut.wrapAround(start: start1, direction: .down, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 8))
        XCTAssertEqual(res1.1, .down)

        let start2 = Point(x: 11, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .down, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 8))
        XCTAssertEqual(res2.1, .down)
    }

    func testArea4Left() {
        let start1 = Point(x: 8, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .left, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 7, y: 4))
        XCTAssertEqual(res1.1, .left)

        let start2 = Point(x: 8, y: 7)
        let res2 = sut.wrapAround(start: start2, direction: .left, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 7, y: 7))
        XCTAssertEqual(res2.1, .left)
    }

    func testArea4Up() {
        let start1 = Point(x: 8, y: 4)
        let res1 = sut.wrapAround(start: start1, direction: .up, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 3))
        XCTAssertEqual(res1.1, .up)

        let start2 = Point(x: 11, y: 4)
        let res2 = sut.wrapAround(start: start2, direction: .up, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 3))
        XCTAssertEqual(res2.1, .up)
    }

    func testArea5Right() {
        let start1 = Point(x: 11, y: 8)
        let res1 = sut.wrapAround(start: start1, direction: .right, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 12, y: 8))
        XCTAssertEqual(res1.1, .right)

        let start2 = Point(x: 11, y: 11)
        let res2 = sut.wrapAround(start: start2, direction: .right, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 12, y: 11))
        XCTAssertEqual(res2.1, .right)
    }

    func testArea5Down() {
        let start1 = Point(x: 8, y: 11)
        let res1 = sut.wrapAround(start: start1, direction: .down, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 3, y: 7))
        XCTAssertEqual(res1.1, .up)

        let start2 = Point(x: 11, y: 11)
        let res2 = sut.wrapAround(start: start2, direction: .down, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 0, y: 7))
        XCTAssertEqual(res2.1, .up)
    }

    func testArea5Left() {
        let start1 = Point(x: 8, y: 8)
        let res1 = sut.wrapAround(start: start1, direction: .left, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 7, y: 7))
        XCTAssertEqual(res1.1, .up)

        let start2 = Point(x: 8, y: 11)
        let res2 = sut.wrapAround(start: start2, direction: .left, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 4, y: 7))
        XCTAssertEqual(res2.1, .up)
    }

    func testArea5Up() {
        let start1 = Point(x: 8, y: 8)
        let res1 = sut.wrapAround(start: start1, direction: .up, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 8, y: 7))
        XCTAssertEqual(res1.1, .up)

        let start2 = Point(x: 11, y: 8)
        let res2 = sut.wrapAround(start: start2, direction: .up, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 7))
        XCTAssertEqual(res2.1, .up)
    }

    func testArea6Right() {
        let start1 = Point(x: 15, y: 8)
        let res1 = sut.wrapAround(start: start1, direction: .right, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 11, y: 3))
        XCTAssertEqual(res1.1, .left)

        let start2 = Point(x: 15, y: 11)
        let res2 = sut.wrapAround(start: start2, direction: .right, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 0))
        XCTAssertEqual(res2.1, .left)
    }

    func testArea6Down() {
        let start1 = Point(x: 12, y: 11)
        let res1 = sut.wrapAround(start: start1, direction: .down, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 0, y: 7))
        XCTAssertEqual(res1.1, .right)

        let start2 = Point(x: 15, y: 11)
        let res2 = sut.wrapAround(start: start2, direction: .down, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 0, y: 4))
        XCTAssertEqual(res2.1, .right)
    }

    func testArea6Left() {
        let start1 = Point(x: 12, y: 8)
        let res1 = sut.wrapAround(start: start1, direction: .left, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 11, y: 8))
        XCTAssertEqual(res1.1, .left)

        let start2 = Point(x: 12, y: 11)
        let res2 = sut.wrapAround(start: start2, direction: .left, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 11))
        XCTAssertEqual(res2.1, .left)
    }

    func testArea6Up() {
        let start1 = Point(x: 12, y: 8)
        let res1 = sut.wrapAround(start: start1, direction: .up, isCube: true)
        XCTAssertEqual(res1.0, .init(x: 11, y: 7))
        XCTAssertEqual(res1.1, .left)

        let start2 = Point(x: 15, y: 8)
        let res2 = sut.wrapAround(start: start2, direction: .up, isCube: true)
        XCTAssertEqual(res2.0, .init(x: 11, y: 4))
        XCTAssertEqual(res2.1, .left)
    }

}
