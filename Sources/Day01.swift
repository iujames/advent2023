import Algorithms

struct Day01: AdventDay {
    var data: String

    func part1() -> Any {
        data.split(separator: "\n").compactMap { line in
            guard let first = line.first(where: { $0.isNumber }),
                    let last = line.last(where: { $0.isNumber }),
                    let value = Int("\(first)\(last)") else { return nil }

            return value
        }.reduce(0, +)
    }

    func part2() -> Any {
        let digits = ["one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"]
        func findInt(line: Substring, reversed: Bool) -> String? {
            var aggregate: String = ""
            let line: [Character] = reversed ? line.reversed() : Array(line)
            for character in line {
                let item = String(character)

                // if this char is a digit, use it
                if character.isNumber { return item }

                if reversed { aggregate = item + aggregate}
                else { aggregate += item }

                // if the aggregate to this point contains a digit word, use it
                for pair in digits {
                    if aggregate.contains(pair.key) { return pair.value }
                }
            }
            return nil
        }

        return data.split(separator: "\n").compactMap { line in
            guard let first = findInt(line: line, reversed: false),
                    let last = findInt(line: line, reversed: true),
                    let value = Int("\(first)\(last)") else { return nil }

            return value
        }.reduce(0, +)
    }
}
