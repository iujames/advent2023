import Algorithms
import CoreGraphics

struct Day07: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        let hands = lines.map { line in
            let split = line.split(separator: " ")
            let cardString = split[0]
            let bid = split[1]
            let cards = Array(cardString)
            let score = score(cards)
            return Hand(bid: Int(bid)!, cards: cards, score: score)
        }

        let sorted = hands.sorted()

        let values = sorted.enumerated().map { index, hand in
            hand.bid * (index + 1)
        }

        return values.reduce(0, +)
    }

    func part2() -> Any {
        let hands = lines.map { line in
            let split = line.split(separator: " ")
            let cardString = split[0]
            let bid = split[1]
            let cards = Array(cardString)
            let score = scoreWild(cards)
            return WildHand(bid: Int(bid)!, cards: cards, score: score)
        }

        let sorted = hands.sorted()

        let values = sorted.enumerated().map { index, hand in
            hand.bid * (index + 1)
        }

        return values.reduce(0, +)
    }

    private func score(_ cards: [Character]) -> Int {
        let groups = Dictionary(grouping: cards) { $0 }
        let maxOfKind = groups.map { $1.count }.max()!

        switch maxOfKind {
        case 5: 
            return 7
        case 4: 
            return 6
        case 3:
            return groups.count == 2 ? 5 : 4
        case 2:
            return groups.count == 3 ? 3 : 2
        default:
            return 1
        }
    }

    private func scoreWild(_ cards: [Character]) -> Int {
        let wilds = cards.filter { $0 == "J" }
        let wildCount = wilds.count

        guard wildCount < 5 else { return 7 }

        let remainder = cards.filter { $0 != "J" }
        let groups = Dictionary(grouping: remainder) { $0 }
        let maxOfKind = groups.map { $1.count }.max()! + wildCount

        switch maxOfKind {
        case 5:
            return 7
        case 4:
            return 6
        case 3:
            // either a full house or three of kind
            return groups.count == 2 ? 5 : 4
        case 2:
            // either two pair or one pair
            return groups.count == 3 ? 3 : 2
        default:
            return 1
        }
    }

    struct Hand: Comparable {
        static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            if lhs.score < rhs.score { return true }
            if lhs.score == rhs.score {
                // compare by card index
                for i in (0..<lhs.cards.count) {
                    let l = cardValue[String(lhs.cards[i])]!
                    let r = cardValue[String(rhs.cards[i])]!
                    if l < r { return true }
                    if l > r { return false }
                }
                return false
            }
            return false
        }

        let bid: Int
        let cards: [Character]
        let score: Int

        static private let cardValue = [
            "A": 14,
            "K": 13,
            "Q": 12,
            "J": 11,
            "T": 10,
            "9": 9,
            "8": 8,
            "7": 7,
            "6": 6,
            "5": 5,
            "4": 4,
            "3": 3,
            "2": 2
        ]
    }

    struct WildHand: Comparable {
        static func < (lhs: Day07.WildHand, rhs: Day07.WildHand) -> Bool {
            if lhs.score < rhs.score { return true }
            if lhs.score == rhs.score {
                // compare by card index
                for i in (0..<lhs.cards.count) {
                    let l = cardValue[String(lhs.cards[i])]!
                    let r = cardValue[String(rhs.cards[i])]!
                    if l < r { return true }
                    if l > r { return false }
                }
                return false
            }
            return false
        }

        let bid: Int
        let cards: [Character]
        let score: Int

        static private let cardValue = [
            "A": 14,
            "K": 13,
            "Q": 12,
            "J": 1, // update card value
            "T": 10,
            "9": 9,
            "8": 8,
            "7": 7,
            "6": 6,
            "5": 5,
            "4": 4,
            "3": 3,
            "2": 2
        ]
    }


}
