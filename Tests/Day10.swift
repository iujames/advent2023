import XCTest

@testable import AdventOfCode

final class Day10Tests: XCTestCase {

    func testPart1a() throws {
        let testData = """
        .....
        .S-7.
        .|.|.
        .L-J.
        .....
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "4")
    }

    func testPart1b() throws {
        let testData = """
        ..F7.
        .FJ|.
        SJ.L7
        |F--J
        LJ...
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }

    func testPart2a() throws {
        let testData = """
        ...........
        .S-------7.
        .|F-----7|.
        .||.....||.
        .||.....||.
        .|L-7.F-J|.
        .|..|.|..|.
        .L--J.L--J.
        ...........
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "4")
    }

    func testPart2b() throws {
        let testData = """
        ..........
        .S------7.
        .|F----7|.
        .||....||.
        .||....||.
        .|L-7F-J|.
        .|..||..|.
        .L--JL--J.
        ..........
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "4")
    }

    func testPart2c() throws {
        let testData = """
        .F----7F7F7F7F-7....
        .|F--7||||||||FJ....
        .||.FJ||||||||L7....
        FJL7L7LJLJ||LJ.L-7..
        L--J.L7...LJS7F-7L7.
        ....F-J..F7FJ|L7L7L7
        ....L7.F7||L7|.L7L7|
        .....|FJLJ|FJ|F7|.LJ
        ....FJL-7.||.||||...
        ....L---J.LJ.LJLJ...
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "8")
    }

    func testPart2d() throws {
        let testData = """
        FF7FSF7F7F7F7F7F---7
        L|LJ||||||||||||F--J
        FL-7LJLJ||||||LJL-77
        F--JF--7||LJLJIF7FJ-
        L---JF-JLJIIIIFJLJJ7
        |F|F-JF---7IIIL7L|7|
        |FFJF7L7F-JF7IIL---7
        7-L-JL7||F7|L7F-7F7|
        L.L7LFJ|||||FJL7||LJ
        L7JLJL-JLJLJL--JLJ.L
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "10")
    }
}
