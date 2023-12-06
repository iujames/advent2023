import Algorithms
import CoreGraphics

struct Day06: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        let times = lines[0].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        let distances = lines[1].split(separator: ":")[1].split(separator: " ").map { Int($0)! }

        let winners = times.enumerated().map { index, time in
            let targetDistance = distances[index]
            return (1..<time).compactMap { i in
                if calculateDistance(hold: i, total: time) > targetDistance {
                    return i
                } else {
                    return nil
                }
            }
        }

        let winnerCounts = winners.map { $0.count }

        return winnerCounts.reduce(1, *)
    }

    func part2() -> Any {
        let times = lines[0].split(separator: ":")[1].split(separator: " ").map { String($0) }
        let distances = lines[1].split(separator: ":")[1].split(separator: " ").map { String($0) }

        let time = Int(String(times.joined()))!
        let distance = Int(String(distances.joined()))!

        var winners = 0
        (1..<time).forEach { i in
            if calculateDistance(hold: i, total: time) > distance {
                winners += 1
            }
        }

        return winners
    }

    private func calculateDistance(hold: Int, total: Int) -> Int {
        guard hold > 0, hold < total else { return 0 }
        let speed = hold
        let remainder = total - hold
        let distance = speed * remainder
        return distance
    }
}
