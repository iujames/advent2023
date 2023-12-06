import XCTest

@testable import AdventOfCode

final class Day06Tests: XCTestCase {

    func testPart1() throws {
        let testData = """
        Time:      7  15   30
        Distance:  9  40  200
        """
        let challenge = Day06(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "288")
    }

    func testPart2() throws {
        let testData = """
        Time:      7  15   30
        Distance:  9  40  200
        """
        let challenge = Day06(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "71503")
    }
}
