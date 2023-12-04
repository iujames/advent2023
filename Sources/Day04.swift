import Algorithms
import CoreGraphics

struct Day04: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {

        lines.map { line in
            let headerSplit = line.split(separator: ":")
            // let header = headerSplit[0]
            let cardData = headerSplit[1]
            let dataSplit = cardData.split(separator: "|")
            let winners = Set(dataSplit[0].trimmingCharacters(in: .whitespaces).split(separator: " ").compactMap { Int(String($0)) })
            let cardValues = Set(dataSplit[1].trimmingCharacters(in: .whitespaces).split(separator: " ").compactMap { Int(String($0)) })
            let cardWinners = winners.intersection(cardValues).count
            if cardWinners == 0 {
                return 0
            } else {
                return Int(pow(2.0, Double(cardWinners - 1)))
            }
        }.reduce(0, +)
    }

    func part2() -> Any {

        var scratchcards = [Int](repeating: 1, count: lines.count)

        lines.enumerated().forEach { index, line in
            let headerSplit = line.split(separator: ":")
            // let header = headerSplit[0]
            let cardData = headerSplit[1]
            let dataSplit = cardData.split(separator: "|")
            let winners = Set(dataSplit[0].trimmingCharacters(in: .whitespaces).split(separator: " ").compactMap { Int(String($0)) })
            let cardValues = Set(dataSplit[1].trimmingCharacters(in: .whitespaces).split(separator: " ").compactMap { Int(String($0)) })
            let cardWinners = winners.intersection(cardValues).count
            let currentItemCount = scratchcards[index]
            for _ in 0..<currentItemCount {
                for i in 0..<cardWinners {
                    scratchcards[index + (i+1)] += 1
                }
            }
        }

        return scratchcards.reduce(0, +)
    }
}
