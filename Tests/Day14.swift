import XCTest

@testable import AdventOfCode

final class Day14Tests: XCTestCase {

    func testPart1() throws {
        let testData = """
        O....#....
        O.OO#....#
        .....##...
        OO.#O....O
        .O.....O#.
        O.#..O.#.#
        ..O..#O..O
        .......O..
        #....###..
        #OO..#....
        """
        let challenge = Day14(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "136")
    }


    func testPart2() throws {
        let testData = """
        O....#....
        O.OO#....#
        .....##...
        OO.#O....O
        .O.....O#.
        O.#..O.#.#
        ..O..#O..O
        .......O..
        #....###..
        #OO..#....
        """
        let challenge = Day14(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "64")
    }


}
