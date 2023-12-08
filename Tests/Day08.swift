import XCTest

@testable import AdventOfCode

final class Day08Tests: XCTestCase {

    func testPart1a() throws {
        let testData = """
        RL

        AAA = (BBB, CCC)
        BBB = (DDD, EEE)
        CCC = (ZZZ, GGG)
        DDD = (DDD, DDD)
        EEE = (EEE, EEE)
        GGG = (GGG, GGG)
        ZZZ = (ZZZ, ZZZ
        """
        let challenge = Day08(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "2")
    }

    func testPart1b() throws {
        let testData = """
        LLR

        AAA = (BBB, BBB)
        BBB = (AAA, ZZZ)
        ZZZ = (ZZZ, ZZZ
        """
        let challenge = Day08(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "6")
    }

    func testPart2() throws {
        let testData = """
        LR

        11A = (11B, XXX)
        11B = (XXX, 11Z)
        11Z = (11B, XXX)
        22A = (22B, XXX)
        22B = (22C, 22C)
        22C = (22Z, 22Z)
        22Z = (22B, 22B)
        XXX = (XXX, XXX)
        """
        let challenge = Day08(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "6")
    }
}
