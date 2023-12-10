import Algorithms

struct Day09: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        let values = lines.map { line in
            let set = line.split(separator: " ").map { Int(String($0))! }
            return solve(set: set)
        }

        return values.reduce(0, +)
    }

    func part2() -> Any {
        let values = lines.map { line in
            let set = line.split(separator: " ").map { Int(String($0))! }
            return solve(set: set.reversed())
        }

        return values.reduce(0, +)
    }

    func solve(set: [Int]) -> Int {
        let setDiffs = (1..<set.count).map { set[$0] - set[$0-1] }
        if set.allSatisfy({ $0 == 0}) { return 0 }
        return set.last! + solve(set: setDiffs)
    }

}
