import Algorithms


struct Day13: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n", omittingEmptySubsequences: false)
    }

    func part1() -> Any {

        var games: [[[String]]] = []

        var game: [[String]] = []
        for line in lines {
            if line.isEmpty {
                games.append(game)
                game = []
                continue
            }

            let chars = Array(line).map { String($0) }
            game.append(chars)
        }
        games.append(game)

        return games.compactMap { game in
            guard game.count > 1 else { return nil }
            if let rows = findHorizontalMirror(game) {
                return rows * 100
            } else if let cols = findVerticalMirror(game) {
                return cols
            }
            return nil
        }.reduce(0, +)
    }

    func part2() -> Any {
        
        var games: [[[String]]] = []

        var game: [[String]] = []
        for line in lines {
            if line.isEmpty {
                games.append(game)
                game = []
                continue
            }

            let chars = Array(line).map { String($0) }
            game.append(chars)
        }
        games.append(game)

        return games.compactMap { game in
            guard game.count > 1 else { return nil }
            if let rows = findHorizontalAlmostMirror(game) {
                return rows * 100
            } else if let cols = findVerticalAlmostMirror(game) {
                return cols
            }
            return nil
        }.reduce(0, +)
    }

    // return the count of rows above it, or nil
    private func findHorizontalMirror(_ game: [[String]]) -> Int? {
        let rows = game.count
        for i in 0..<rows {
            if isMirror(splitAtIndex: i, game: game) { return i+1 }
        }
        return nil
    }

    // return the count of cols left of it, or nit
    private func findVerticalMirror(_ game: [[String]]) -> Int? {
        // reconfigure cols into rows

        let cols = game[0].count

        var newGame: [[String]] = []

        for x in 0..<cols {
            newGame.append(game.map { $0[x] })
        }

        for i in 0..<newGame.count {
            if isMirror(splitAtIndex: i, game: newGame) { return i+1 }
        }
        return nil
    }

    // first batch is up to and including splitAt
    private func isMirror(splitAtIndex: Int, game: [[String]]) -> Bool {
        let splitCount = splitAtIndex + 1
        var first = Array(game.prefix(splitCount))
        var last = Array(game.suffix(game.count - splitCount))

        guard !first.isEmpty, !last.isEmpty else { return false }

        if first.count < last.count {
            last = Array(last.prefix(first.count))
        }
        else if first.count > last.count {
            first = Array(first.suffix(last.count))
        }

        let count = first.count
        for i in 0..<count {
            let item1 = first[i]
            let item2 = last[count-1-i]

            for j in 0..<item1.count {
                if item1[j] != item2[j] { return false }
            }
        }
        return true
    }

    private func findHorizontalAlmostMirror(_ game: [[String]]) -> Int? {
        let rows = game.count
        for i in 0..<rows {
            if isAlmostMirror(splitAtIndex: i, game: game) { return i+1 }
        }
        return nil
    }

    // return the count of cols left of it, or nit
    private func findVerticalAlmostMirror(_ game: [[String]]) -> Int? {
        // reconfigure cols into rows

        let cols = game[0].count

        var newGame: [[String]] = []

        for x in 0..<cols {
            newGame.append(game.map { $0[x] })
        }

        for i in 0..<newGame.count {
            if isAlmostMirror(splitAtIndex: i, game: newGame) { return i+1 }
        }
        return nil
    }

    // first batch is up to and including splitAt
    private func isAlmostMirror(splitAtIndex: Int, game: [[String]]) -> Bool {
        let splitCount = splitAtIndex + 1
        var first = Array(game.prefix(splitCount))
        var last = Array(game.suffix(game.count - splitCount))

        guard !first.isEmpty, !last.isEmpty else { return false }

        if first.count < last.count {
            last = Array(last.prefix(first.count))
        }
        else if first.count > last.count {
            first = Array(first.suffix(last.count))
        }

        let count = first.count
        var differences = 0
        for i in 0..<count {
            let item1 = first[i]
            let item2 = last[count-1-i]

            for j in 0..<item1.count {
                if item1[j] != item2[j] { differences += 1 }
                if differences > 1 { break }
            }

            if differences > 1 { break }
        }
        return differences == 1
    }


}
