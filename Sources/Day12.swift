import Algorithms


struct Day12: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        
        return lines.map { line in
            let split = line.split(separator: " ")
            let slots = Array(split[0]).map { String($0) }
            let counts = split[1].split(separator: ",").map { Int(String($0))! }
            return solveRow(slots: slots, counts: counts)
        }.reduce(0, +)
    }

    func part2() -> Any {
        
        return lines.enumerated().map { index, line in
            let split = line.split(separator: " ")
            let slots = Array(split[0]).map { String($0) }
            let counts = split[1].split(separator: ",").map { Int(String($0))! }
            let unfoldedSlots = unfoldSlots(slots, folds: 5)
            let unfoldedCounts = unfoldCounts(counts, folds: 5)
            let count = solveRow(slots: unfoldedSlots, counts: unfoldedCounts)
            print("line \(index), solution \(count)")
            return count
        }.reduce(0, +)
    }

    private func unfoldSlots(_ slots: [String], folds: Int) -> [String] {
        let section = String(slots.joined()) + "?"
        let combined = Array(repeating: section, count: folds)
        var merged = combined.joined()
        merged.removeLast()
        return Array(merged).map { String($0) }
    }

    private func unfoldCounts(_ counts: [Int], folds: Int) -> [Int] {
        let combined = Array(repeating: counts, count: folds)
        return combined.flatMap { $0 }
    }

    private func solveRow(slots: [String], counts: [Int]) -> Int {
        guard !slots.isEmpty else {
            // if no items left todo, it was a solve, else it was a fail
            return counts.isEmpty ? 1 : 0
        }

        let item = slots[0]

        switch item {
        case ".":
            return solveRow(slots: slots.suffix(slots.count - 1), counts: counts)
        case "?":
            var test1 = slots
            var test2 = slots
            test1[0] = "."
            test2[0] = "#"
            return solveRow(slots: test1, counts: counts) + solveRow(slots: test2, counts: counts)
        case "#":
            guard !counts.isEmpty else { return 0 }
            let count = counts[0]
            let range = slots.prefix(count+1)
            let match = range.prefix(count)
            if match.count == count && match.allSatisfy({ $0 != "." }) && (range.count == match.count || range.last != "#") {
                // match
                return solveRow(slots: slots.suffix(slots.count - range.count), counts: counts.suffix(counts.count - 1))
            } else {
                // not a match
                return 0
            }

        default:
            return 0
        }
    }



//    private func solveRow(slots: [String], counts: [Int]) -> Int {
//        let solutions = checkItem(slots: slots, itemIndex: 0, startOffset: 0, counts: counts)
//        return solutions.count
//    }

//    private func checkItem(slots: [String], itemIndex: Int, startOffset: Int, counts: [Int]) -> Set<String> {
//        guard itemIndex < counts.count else { return Set<String>() }
//        if let test = createTest(itemIndex: itemIndex, startOffset: startOffset, counts: counts, max: slots.count) {
//            // a valid test, check if it is ok and keep incrementing the startOffset
//            let testChars = Array(test)
//            var isValid = true
//            for i in 0..<slots.count {
//                // compare test with slots, if we ever hit a spot where the test has # and the
//                // slots is not # or ?, it is invalid
//                let orig = slots[i]
//                let item = String(testChars[i])
//                if item == "#" && orig != "#" && orig != "?" {
//                    isValid = false
//                    break
//                }
//            }
//            var set = Set<String>()
//            if isValid {
//                set.insert(test)
//            }
//            let recursiveSolve = checkItem(slots: slots, itemIndex: itemIndex, startOffset: startOffset+1, counts: counts)
//            return set.union(recursiveSolve)
//        } else {
//            // not a valid test, need to reset and move on to next item index
//            return checkItem(slots: slots, itemIndex: itemIndex+1, startOffset: 0, counts: counts)
//        }
//    }
//
//    // need to find the first ? where it could fit, after some offset, then try to fit others
//
//    private func createTest(itemIndex: Int, startOffset: Int, counts: [Int], max: Int) -> String? {
//        var test: String = ""
//        for i in 0..<counts.count {
//            let count = counts[i]
//            if i == itemIndex {
//                (0..<startOffset).forEach { _ in test += "." }
//            }
//            (0..<count).forEach { _ in test += "#" }
//            if i < counts.count - 1 {
//                test += "."
//            }
//        }
//
//        if test.count < max {
//            // pad
//            (0..<(max-test.count)).forEach { _ in test += "."}
//            return test
//        } else if test.count > max {
//            return nil
//        } else {
//            return test
//        }
//    }
}
