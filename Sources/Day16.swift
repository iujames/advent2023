import Algorithms


struct Day16: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {

        // y/x mapping of tiles
        let tiles = lines.map { line in
            Array(line).map { item in
                Tile(symbol: String(item), energizedFrom: [])
            }

        }
        
        return checkBeam(tiles, initial: Move(heading: .right, x: 0, y: 0))
    }

    func part2() -> Any {

        // y/x mapping of tiles
        let tiles = lines.map { line in
            Array(line).map { item in
                Tile(symbol: String(item), energizedFrom: [])
            }

        }

        let rows = tiles.count
        let cols = tiles[0].count

        var moves: [Move] = []

        for y in 0..<rows {
            moves.append(Move(heading: .right, x: 0, y: y))
            moves.append(Move(heading: .left, x: cols-1, y: y))
        }

        for x in 0..<cols {
            moves.append(Move(heading: .down, x: x, y: 0))
            moves.append(Move(heading: .up, x: x, y: rows-1))
        }

        return moves.map { move in checkBeam(tiles, initial: move) }.max()!
    }

    func checkBeam(_ tiles: [[Tile]], initial: Move) -> Int {
        var tiles = tiles
        let rows = tiles.count
        let cols = tiles[0].count

        func process(x: Int, y: Int, heading: Direction) -> [Move] {
            guard x >= 0, x < cols, y >= 0, y < rows else { return [] }

            var tile = tiles[y][x]
            // if its already energized from this direction, its re-looping, done
            guard !tile.energizedFrom.contains(where: { $0 == heading}) else { return [] }

            tile.energizedFrom.append(heading)
            tiles[y][x] = tile

            switch (tile.symbol, heading) {
            case (".", .right), ("-", .right):
                return [Move(heading: .right, x: x+1, y: y)]
            case (".", .left), ("-", .left):
                return [Move(heading: .left, x: x-1, y: y)]
            case (".", .up), ("|", .up):
                return [Move(heading: .up, x: x, y: y-1)]
            case (".", .down), ("|", .down):
                return [Move(heading: .down, x: x, y: y+1)]
            case ("/", .right):
                return [Move(heading: .up, x: x, y: y-1)]
            case ("/", .left):
                return [Move(heading: .down, x: x, y: y+1)]
            case ("/", .up):
                return [Move(heading: .right, x: x+1, y: y)]
            case ("/", .down):
                return [Move(heading: .left, x: x-1, y: y)]
            case ("\\", .right):
                return [Move(heading: .down, x: x, y: y+1)]
            case ("\\", .left):
                return [Move(heading: .up, x: x, y: y-1)]
            case ("\\", .up):
                return [Move(heading: .left, x: x-1, y: y)]
            case ("\\", .down):
                return [Move(heading: .right, x: x+1, y: y)]
            case ("|", .right), ("|", .left):
                return [Move(heading: .up, x: x, y: y-1), Move(heading: .down, x: x, y: y+1)]
            case ("-", .up), ("-", .down):
                return [Move(heading: .right, x: x+1, y: y), Move(heading: .left, x: x-1, y: y)]
            default:
                return []
            }
        }

        var moves: [Move] = [initial]

        while !moves.isEmpty {
            let move = moves.removeFirst()
            let newMoves = process(x: move.x, y: move.y, heading: move.heading)
            moves.append(contentsOf: newMoves)
        }

        //debug(tiles)

        return tiles.map { tileRow in
            tileRow.filter { !$0.energizedFrom.isEmpty }.count
        }.reduce(0, +)
    }

  
    enum Direction {
        case left, right, up, down
    }

    struct Tile {
        let symbol: String
        var energizedFrom: [Direction]
    }

    struct Move {
        let x: Int
        let y: Int
        let heading: Direction

        init(heading: Direction, x: Int, y: Int) {
            self.x = x
            self.y = y
            self.heading = heading
        }
    }

    private func debug(_ grid: [[Tile]]) {
        print()
        print()
        let rows = grid.count
        for y in 0..<rows {
            let row = grid[y].map { $0.energizedFrom.isEmpty ? "." : "#" }.joined()
            print(row)
        }
    }
}
