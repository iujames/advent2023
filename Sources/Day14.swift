import Algorithms


struct Day14: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {

        // read into y/x grid
        let rows = lines.count
        let cols = lines[0].count

        var platform = Array(repeating: Array(repeating: ".", count: cols), count: rows)

        for y in 0..<rows {
            let line = Array(lines[y])
            for x in 0..<cols {
                let item = String(line[x])
                platform[y][x] = item
            }
        }

        // tilt north
        // start at bottom row and move any 0 up that can, and any 0 directly below it
        for y in stride(from: rows - 1, through: 1, by: -1) {
            for x in 0..<cols {
                if platform[y][x] == "O" && platform[y-1][x] == "." {
                    // it can move up
                    platform[y-1][x] = "O"

                    // pull up every item below until a # is hit
                    for i in y..<rows {
                        if platform[i][x] == "#" { break }
                        platform[i-1][x] = platform[i][x]
                        platform[i][x] = "."
                    }
                }
            }
        }

        return platform.enumerated().map { index, row in
            row.filter { $0 == "O" }.count * (rows - index)
        }.reduce(0, +)
    }

    func part2() -> Any {

        // read into y/x grid
        let rows = lines.count
        let cols = lines[0].count

        var platform = Array(repeating: Array(repeating: ".", count: cols), count: rows)

        for y in 0..<rows {
            let line = Array(lines[y])
            for x in 0..<cols {
                let item = String(line[x])
                platform[y][x] = item
            }
        }


        // tilt in a spin: north, west, south, east


        // 1_000_000_000 cycles

        var previous: [String: Int] = [:]

        var limit = 1_000_000_000
        var index = 0

        while index < limit {

            // tilt north
            // start at bottom row and move any 0 up that can, and any 0 directly below it
            for y in stride(from: rows - 1, through: 1, by: -1) {
                for x in 0..<cols {
                    if platform[y][x] == "O" && platform[y-1][x] == "." {
                        // it can move up
                        platform[y-1][x] = "O"

                        // pull up every item below until a # is hit
                        for i in y..<rows {
                            if platform[i][x] == "#" { break }
                            platform[i-1][x] = platform[i][x]
                            platform[i][x] = "."
                        }
                    }
                }
            }

            //debug(platform)

            // tilt west
            // start at right col and move any 0 left that can, and any 0 directly right of it
            for x in stride(from: cols - 1, through: 1, by: -1) {
                for y in 0..<rows {
                    if platform[y][x] == "O" && platform[y][x-1] == "." {
                        // it can move left
                        platform[y][x-1] = "O"

                        // pull left every item right until a # is hit
                        for i in x..<cols {
                            if platform[y][i] == "#" { break }
                            platform[y][i-1] = platform[y][i]
                            platform[y][i] = "."
                        }
                    }
                }
            }

            //debug(platform)

            // tilt south
            // start at top row and move any 0 down that can, and any 0 directly above it
            for y in stride(from: 0, to: rows-1, by: 1) {
                for x in 0..<cols {
                    if platform[y][x] == "O" && platform[y+1][x] == "." {
                        // it can move down
                        platform[y+1][x] = "O"
                        platform[y][x] = "." // fill spot

                        // pull down every item above until a # is hit
                        for i in stride(from: y-1, through: 0, by: -1) {
                            if platform[i][x] == "#" { break }
                            platform[i+1][x] = platform[i][x]
                            platform[i][x] = "."
                        }
                    }
                }
            }

            //debug(platform)

            // tilt east
            // start at left col and move any 0 right that can, and any 0 directly left of it
            for x in stride(from: 0, to: cols-1, by: 1) {
                for y in 0..<rows {
                    if platform[y][x] == "O" && platform[y][x+1] == "." {
                        // it can move right
                        platform[y][x+1] = "O"
                        platform[y][x] = "."

                        // pull right every item left until a # is hit
                        for i in stride(from: x-1, through: 0, by: -1) {
                            if platform[y][i] == "#" { break }
                            platform[y][i+1] = platform[y][i]
                            platform[y][i] = "."
                        }
                    }
                }
            }

            //debug(platform)

            let cycleValue = toString(platform)

            let load = platform.enumerated().map { index, row in
                row.filter { $0 == "O" }.count * (rows - index)
            }.reduce(0, +)

            print("cycle \(index+1) load \(load)")

            if let prior = previous[cycleValue] {
                print("** cycle \(index+1) match \(prior)")
                //break

                // found the cycle, compute the cycle length and ffwd to end
                let cycleLength = index + 1 - prior
                let remaining = (1_000_000_000 - index - 1) % cycleLength

                print(remaining)

                limit = index + remaining + 1
            }


            previous[cycleValue] = index+1
            //print("cycle \(cycle)")

            //if cycleValue == value { break }


            index += 1
        }

        return platform.enumerated().map { index, row in
            row.filter { $0 == "O" }.count * (rows - index)
        }.reduce(0, +)
    }



    private func debug(_ grid: [[String]]) {
        print()
        print()
        let rows = grid.count
        for y in 0..<rows {
            let row = grid[y].joined()
            print(row)
        }
    }

    private func toString(_ grid: [[String]]) -> String {
        var value = ""
        let rows = grid.count
        for y in 0..<rows {
            let row = grid[y].joined()
            value += row
        }
        return value
    }

}
