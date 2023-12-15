import XCTest

@testable import AdventOfCode

final class Day15Tests: XCTestCase {

    func testPart1() throws {
        let testData = """
        rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
        """
        let challenge = Day15(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "1320")
    }


    func testPart2() throws {
        let testData = """
        rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
        """
        let challenge = Day15(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "145")
    }


}
