import Algorithms


struct Day10: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {

        // gather all up into structure keyed by x/y index
        var start: Point = Point(x: 0, y: 0)

        //                x,y       1: x,y       2: x,y
        var pipeMap: [Point: (Point, Point)] = [:]

        lines.enumerated().forEach { y, line in
            let chars = Array(line)

            for x in (0..<chars.count) {
                let point = Point(x: x, y: y)
                
                switch chars[x] {
                case "|": // north/south
                    pipeMap[point] = (Point(x: x, y: y-1), Point(x: x, y: y+1))
                case "-": //east/west
                    pipeMap[point] = (Point(x: x+1, y: y), Point(x: x-1, y: y))
                case "L": //north east
                    pipeMap[point] = (Point(x: x, y: y-1), Point(x: x+1, y: y))
                case "J": // north west
                    pipeMap[point] = (Point(x: x, y: y-1), Point(x: x-1, y: y))
                case "7": // south west
                    pipeMap[point] = (Point(x: x, y: y+1), Point(x: x-1, y: y))
                case "F": // south east
                    pipeMap[point] = (Point(x: x, y: y+1), Point(x: x+1, y: y))
                case "S":
                    start = point
                default:
                    break
                }
            }
        }

        // take start point and find 2 possible directions it can take
        let minX = max(0, start.x - 1)
        let maxX = min(lines[0].count - 1, start.x + 1)
        let minY = max(0, start.y - 1)
        let maxY = min(lines.count - 1, start.y + 1)

        var startPoints: [Point] = []

        for x in minX...maxX {
            for y in minY...maxY {
                let point = Point(x: x, y: y)
                if point != start {
                    if let lookup = pipeMap[point] {
                        if lookup.0 == start {
                            startPoints.append(point)
                        } else if lookup.1 == start {
                            startPoints.append(point)
                        }
                    }
                }
            }
        }

        var prevPoint1 = start
        var prevPoint2 = start
        var point1 = startPoints[0]
        var point2 = startPoints[1]

        var steps = 1

        while point1 != point2 {
            steps += 1

            let map1 = pipeMap[point1]!
            let map2 = pipeMap[point2]!

            let tmp1 = point1
            let tmp2 = point2

            point1 = (map1.0 == prevPoint1) ? map1.1 : map1.0
            point2 = (map2.0 == prevPoint2) ? map2.1 : map2.0

            prevPoint1 = tmp1
            prevPoint2 = tmp2
        }


        return steps
    }

    func part2() -> Any {
        
        // map it out then find every open spot and try to exit

        // algo for "can escape"...
        // needs to keep track of already explored coords to avoid infinite search
        // take a point and then find any neighbor points that can be explored, recurse
        // success if x is 0 or max, y is 0 or max
        // need to distinguish which are part of main loop

        // need a lookup of main loop coords


        let maxX = lines[0].count
        let maxY = lines.count
        var startX = 0
        var startY = 0

        // lookup y,x of any item on the board
        var charLookup = Array(repeating: Array(repeating: ".", count: maxY), count: maxX)

        for y in 0..<maxY {
            let line = Array(lines[y])
            for x in 0..<maxX {
                let item = String(line[x])
                charLookup[x][y] = item

                if item == "S" {
                    startX = x
                    startY = y
                }
            }
        }

        // any x,y coord is marked true here if it is part of the main loop
        var loopLookup = Array(repeating: Array(repeating: false, count: maxY), count: maxX)

        // start at start point and follow it until back to start
        loopLookup[startX][startY] = true

        var loopDone = false
        var loopX = startX
        var loopY = startY
        var loopPrevX: Int? = nil
        var loopPrevY: Int? = nil

        while !loopDone {
            let next = findNextLoopIndex(x: loopX, y: loopY, prevX: loopPrevX, prevY: loopPrevY, lookup: charLookup)
            loopLookup[next.0][next.1] = true
            loopDone = next.0 == startX && next.1 == startY
            if !loopDone {
                loopPrevX = loopX
                loopPrevY = loopY
                loopX = next.0
                loopY = next.1
            }
        }

        // go through points NOT in loop
        // quick check if they can exit straight in any direction without hitting a loop index - not in loop
        // if in loop, more advanced escape search needed

//        var enclosed = 0
//
//        for x in 0..<maxX {
//            for y in 0..<maxY {
//                if loopLookup[x][y] { continue } // part of the loop path
//                var visited = Array(repeating: Array(repeating: false, count: maxY), count: maxX)
//                visited[x][y] = true
//                if !canEscape(x: x, y: y, visited: visited, inLoop: loopLookup, charLookup: charLookup) {
//                    enclosed += 1
//                }
//            }
//        }

        var fillLookup = Array(repeating: Array(repeating: false, count: maxY), count: maxX)
        // go through loop lookup, and fill items right and down where possible until hitting another pipe

        // if the count is odd, then (𝑥,𝑦) is inside the enclosed region; otherwise, it's outside.

        // count: touched an edge and went inside

        //let terminators = ["S", "F", "7", "L", "J", "|"]
        let terminators = ["L", "J", "|", "S"]
        for y in 0..<maxY {
            var pathCount = 0
            for x in 0..<maxX {
                let char = charLookup[x][y]
                let touchingPath = loopLookup[x][y]
                
                if touchingPath && terminators.contains(char) {
                    pathCount += 1
                }

                if pathCount % 2 != 0 {
                    fillLookup[x][y] = true
                }
            }
        }



        var enclosed = 0
        for y in 0..<maxY {
            for x in 0..<maxX {
                if !loopLookup[x][y] && fillLookup[x][y] {
                    print("\(x), \(y)")
                    enclosed += 1
                }
            }
        }

        return enclosed
    }

    private func canEscape(x: Int, y: Int, visited: [[Bool]], inLoop: [[Bool]], charLookup: [[String]]) -> Bool {
        let minX = 0
        let maxX = inLoop.count
        let minY = 0
        let maxY = inLoop[0].count

        if x == minX || x == maxX - 1 { return true }
        if y == minY || y == maxY - 1 { return true }

        let current = charLookup[x][y]

        // check moves top, bottom, left, right - are any available? if so, take it an recurse
        // see if any succeed

        var escaped = false

        // can move to top if it is not: -, F, 7
        if y > 0 {
            let notAllowed = ["-", "F", "7"]
            if !visited[x][y-1] && current != "-" && (!inLoop[x][y-1] || !notAllowed.contains(charLookup[x][y-1])) {
                var visited = visited
                visited[x][y-1] = true
                escaped = canEscape(x: x, y: y-1, visited: visited, inLoop: inLoop, charLookup: charLookup)
            }
        }

        if escaped {
            return true
        }

        // can move to bottom if it is not -, L, J
        if y < maxY - 1 {
            let notAllowed = ["-", "F", "J"]
            if !visited[x][y+1] && current != "-" && (!inLoop[x][y+1] || !notAllowed.contains(charLookup[x][y+1])) {
                var visited = visited
                visited[x][y+1] = true
                escaped = canEscape(x: x, y: y+1, visited: visited, inLoop: inLoop, charLookup: charLookup)
            }
        }

        if escaped {
            return true
        }

        // can move left if it is not |, F, L
        if x > 0 {
            let notAllowed = ["|", "F", "L"]
            if !visited[x-1][y] && current != "|" && (!inLoop[x-1][y] || !notAllowed.contains(charLookup[x-1][y])) {
                var visited = visited
                visited[x-1][y] = true
                escaped = canEscape(x: x-1, y: y, visited: visited, inLoop: inLoop, charLookup: charLookup)
            }
        }

        if escaped {
            return true
        }

        // can move right if it is not |, J, 7
        if x < maxX - 1 {
            let notAllowed = ["|", "J", "7"]
            if !visited[x+1][y] && current != "|" && (!inLoop[x+1][y] || !notAllowed.contains(charLookup[x+1][y])) {
                var visited = visited
                visited[x+1][y] = true
                escaped = canEscape(x: x+1, y: y, visited: visited, inLoop: inLoop, charLookup: charLookup)
            }
        }

        if escaped {
            return true
        }

        return escaped
    }

    private func findNextLoopIndex(x: Int, y: Int, prevX: Int?, prevY: Int?, lookup: [[String]]) -> (Int, Int) {
        let maxX = lookup.count
        let maxY = lookup[0].count

        // going up, could be |, 7 or F
        if y > 0, prevY != y-1 {
            let above = lookup[x][y-1]
            if above == "|" || above == "7" || above == "F" || above == "S" { return (x, y-1) }
        }

        // going down, could be |, L, J
        if y+1 < maxY, prevY != y+1 {
            let below = lookup[x][y+1]
            if below == "|" || below == "L" || below == "J" || below == "S" { return (x, y+1) }
        }

        // going left, could be -, L, F
        if x > 0, prevX != x-1 {
            let left = lookup[x-1][y]
            if left == "-" || left == "L" || left == "F" || left == "S" { return (x-1, y) }
        }

        // going right, could be -, J, 7
        if x+1 < maxX, prevX != x+1 {
            let right = lookup[x+1][y]
            if right == "-" || right == "J" || right == "7" || right == "S" { return (x+1, y) }
        }

        return (0,0)
    }

    struct Point: Hashable {
        let x: Int
        let y: Int

        static func == (lhs: Day10.Point, rhs: Day10.Point) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }
}
