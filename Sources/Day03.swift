import Algorithms

struct Day03: AdventDay {
    var data: String

    func part1() -> Any {

        // get into 2-d array
        // organize values with their x start-end and y
        // organize symbols w/ their x-y
        // check numbers for adjacent symbols to count them

        let lines = data.split(separator: "\n")
        let height = lines.count
        let width = lines[0].count

        // symbols[x][y] will tell if there is a symbol at that spot
        var symbols = [[Bool]](repeating: [Bool](repeating: false, count: height), count: width)
        var parts: [PartNumber] = []

        for y in 0..<height {
            let line = Array(lines[y])
            var part: PartNumber?
            for x in 0..<width {
                let char = line[x]
                if char.isNumber {
                    if part == nil {
                        part = PartNumber(startX: x, y: y)
                    }
                    part!.charValues.append(char)
                } else {
                    if let currentPart = part {
                        parts.append(currentPart)
                        part = nil
                    }

                    if char != "." {
                        symbols[x][y] = true
                    }
                }
            }
            if let currentPart = part {
                parts.append(currentPart)
            }
        }

        // find valid parts - those with an adjacent symbol
        let validParts = parts.compactMap { part in

            // check immediate left
            if part.startX > 0 && symbols[part.startX - 1][part.y] { return part.intValue }

            // check immediate right
            if part.endX < width - 2 && symbols[part.endX + 1][part.y] { return part.intValue }

            let startX = part.startX > 0 ? part.startX - 1 : part.startX
            let endX = part.endX < width - 2 ? part.endX + 1 : part.endX

            // check row above
            if part.y > 0 {
                for x in startX...endX {
                    if symbols[x][part.y - 1] { return part.intValue }
                }
            }

            // check row below
            if part.y < height - 1 {
                for x in startX...endX {
                    if symbols[x][part.y + 1] { return part.intValue }
                }
            }

            return nil
        }

        return validParts.reduce(0, +)
    }

    func part2() -> Any {

        let lines = data.split(separator: "\n")
        let height = lines.count
        let width = lines[0].count

        // search to a gear
        // search around the gear for adjacent parts
        // capture gear if exactly 2 adjacent parts

        // find the gear
        // there are 8 adjacent spots
        // need to extend left and right until non-digit found
        // find the number of parts in that range
        // check for edges of data

        var gears: [Gear] = []

        func getParts(y: Int, startX: Int, endX: Int) -> [PartNumber] {
            let line = Array(lines[y])

            // see if start x should extend left
            var startX = startX
            while line[startX].isNumber {
                if startX == 0 { break }
                startX -= 1
            }

            // see if end x should extend right
            var endX = endX
            while line[endX].isNumber {
                if endX == width - 1 { break }
                endX += 1
            }

            // gather parts between start and end
            var parts: [PartNumber] = []
            var part: PartNumber?
            for x in startX...endX {
                let char = line[x]
                if char.isNumber {
                    if part == nil {
                        part = PartNumber(startX: x, y: y)
                    }
                    part!.charValues.append(char)
                } else {
                    if let currentPart = part {
                        parts.append(currentPart)
                        part = nil
                    }
                }
            }
            if let currentPart = part {
                parts.append(currentPart)
                part = nil
            }

            return parts
        }

        for y in 0..<height {
            let line = Array(lines[y])
            for x in 0..<width {
                let char = line[x]
                if char == "*" {
                    var gear = Gear(x: x, y: y)

                    let startX = x > 0 ? x - 1 : x
                    let endX = x < width - 1 ? x + 1 : x

                    // get row above, extend left and right as needed
                    if y > 0 {
                        gear.parts.append(contentsOf: getParts(y: y - 1, startX: startX, endX: endX))
                    }

                    // get row below, extend left and right as needed
                    if y < height - 1 {
                        gear.parts.append(contentsOf: getParts(y: y + 1, startX: startX, endX: endX))
                    }

                    // get directly left
                    if startX < x {
                        gear.parts.append(contentsOf: getParts(y: y, startX: startX, endX: x))
                    }

                    // get directly right
                    if endX > x {
                        gear.parts.append(contentsOf: getParts(y: y, startX: x, endX: endX))
                    }

                    gears.append(gear)
                }
            }
        }

        let validGears = gears.filter { $0.parts.count == 2 }
        let gearRatios = validGears.map { $0.parts[0].intValue * $0.parts[1].intValue }

        return gearRatios.reduce(0, +)
    }

    struct Gear {
        let x: Int
        let y: Int
        var parts: [PartNumber] = []
    }

    struct PartNumber {
        let startX: Int
        let y: Int
        var charValues: [Character] = []
        var intValue: Int {
            Int(String(charValues))!
        }
        var endX: Int {
            startX + (charValues.count - 1)
        }
    }


}
