import Algorithms


struct Day11: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        let rows = lines.count
        let cols = lines[0].count

        // find expansion
        var universe = Array(repeating: Array(repeating: ".", count: rows), count: cols)

        var galaxyRows = Array(repeating: false, count: rows)
        var galaxyCols = Array(repeating: false, count: cols)

        // gather data into row/col structure and find those without a galaxy to expand
        for y in 0..<lines.count {
            let line = Array(lines[y])
            for x in 0..<line.count {
                let char = line[x]
                universe[x][y] = String(char)
                if char == "#" {
                    galaxyRows[y] = true
                    galaxyCols[x] = true
                }
            }
        }

        //debug(universe)

        // now insert expansion
        for index in stride(from: galaxyCols.count - 1, through: 0, by: -1) {
            if !galaxyCols[index] {
                universe.insert(Array(repeating: ".", count: rows), at: index)
            }
        }

        //debug(universe)

        for index in stride(from: galaxyRows.count - 1, through: 0, by: -1) {
            if !galaxyRows[index] {
                for x in 0..<universe.count {
                    var column = universe[x]
                    column.insert(".", at: index)
                    universe[x] = column
                }
            }
        }

        //debug(universe)

        // find the location of galaxies and index them
        var galaxies: [(Int, Int)] = []

        for y in 0..<universe[0].count {
            for x in 0..<universe.count {
                if universe[x][y] == "#" {
                    galaxies.append((x, y))
                }
            }
        }

        // find distance between 0 and every other
        // find distance between 1 and every other except 0
        // find distance between 2 and every other except 0 and 1..

        var startIndex = 0
        var pathLength = 0
        let endIndex = galaxies.count - 1

        while startIndex < endIndex {
            // find paths
            let galaxy = galaxies[startIndex]

            for i in (startIndex+1)...endIndex {
                let other = galaxies[i]

                let deltaX = abs(other.0 - galaxy.0)
                let deltaY = abs(other.1 - galaxy.1)
                pathLength += deltaX + deltaY
            }

            startIndex += 1
        }

        return pathLength
    }

    func part2() -> Any {
        
        let rows = lines.count
        let cols = lines[0].count

        let expansionCount = 1_000_000

        // find expansion
        var universe = Array(repeating: Array(repeating: ".", count: rows), count: cols)

        var galaxyRows = Array(repeating: false, count: rows)
        var galaxyCols = Array(repeating: false, count: cols)

        // gather data into row/col structure and find those without a galaxy to expand
        for y in 0..<lines.count {
            let line = Array(lines[y])
            for x in 0..<line.count {
                let char = line[x]
                universe[x][y] = String(char)
                if char == "#" {
                    galaxyRows[y] = true
                    galaxyCols[x] = true
                }
            }
        }

        //debug(universe)

//        // now insert expansion
//        for index in stride(from: galaxyCols.count - 1, through: 0, by: -1) {
//            if !galaxyCols[index] {
//                (0..<expansionCount-1).forEach { _ in
//                    universe.insert(Array(repeating: ".", count: rows), at: index)
//                }
//            }
//        }
//
//        //debug(universe)
//
//        for index in stride(from: galaxyRows.count - 1, through: 0, by: -1) {
//            if !galaxyRows[index] {
//                for x in 0..<universe.count {
//                    var column = universe[x]
//                    (0..<expansionCount-1).forEach { _ in
//                        column.insert(".", at: index)
//                    }
//                    universe[x] = column
//                }
//            }
//        }

        //debug(universe)

        // find the location of galaxies and index them
        var galaxies: [(Int, Int)] = []

        var expandedRows = 0
        for y in 0..<universe[0].count {
            if !galaxyRows[y] {
                expandedRows += 1
            } else {
                var expandedCols = 0
                for x in 0..<universe.count {
                    if !galaxyCols[x] {
                        expandedCols += 1
                    } else if universe[x][y] == "#" {
                        let galaxyX = x + (expandedCols * (expansionCount-1))
                        let galaxyY = y + (expandedRows * (expansionCount-1))
                        galaxies.append((galaxyX, galaxyY))
                    }
                }
            }
        }

        // find distance between 0 and every other
        // find distance between 1 and every other except 0
        // find distance between 2 and every other except 0 and 1..

        var startIndex = 0
        var pathLength = 0
        let endIndex = galaxies.count - 1

        while startIndex < endIndex {
            // find paths
            let galaxy = galaxies[startIndex]

            for i in (startIndex+1)...endIndex {
                let other = galaxies[i]

                let deltaX = abs(other.0 - galaxy.0)
                let deltaY = abs(other.1 - galaxy.1)
                pathLength += deltaX + deltaY
            }

            startIndex += 1
        }

        return pathLength
    }

    private func debug(_ universe: [[String]]) {
        print()
        print()
        let rows = universe[0].count
        for x in 0..<rows {
            let row = universe.map { $0[x] }.joined()
            print(row)
        }
    }
}
