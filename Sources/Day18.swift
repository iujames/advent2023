import Algorithms
import Foundation

struct Day18: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {

        let planItems = mapPlan(lines)

        let grid = buildGrid(planItems)

        //debug(grid)

        //let filled = fillGrid(grid)

        let filled = fillGrid2(grid)

        //debug(filled)

        return filled.map { row in
            var count = 0
            for x in 0..<row.count {
                if row[x] == "#" { count += 1 }
            }
            return count
        }.reduce(0, +)
    }

    func part2() -> Any {

        let planItems = mapPlan2(lines)

        let grid = buildGrid2(planItems)

        //debug(grid)

        //let filled = fillGrid(grid)

        let filled = fillGrid3(grid)

        //debug(filled)

        return filled.map { row in
            var count = 0
            for x in 0..<row.count {
                if row[x] { count += 1 }
            }
            return count
        }.reduce(0, +)
    }

    private func fillGrid2(_ grid: [[String]]) -> [[String]] {
        var grid = grid
        let rows = grid.count
        let cols = grid[0].count

        // find a starting point inside the grid
        var x = 0
        let y = 1
        var seenEdge = false
        let row = grid[y]
        for i in 0..<cols {
            x = i
            let item = row[i]
            if item == "#" { seenEdge = true }
            else if seenEdge { break }
        }

        let startingPoint = (x, y)

        grid[startingPoint.1][startingPoint.0] = "#"

        var fillPoints: [(Int, Int)] = [startingPoint]

        while !fillPoints.isEmpty {
            let point = fillPoints.removeFirst()
            let x = point.0
            let y = point.1

            // check row above
            let minY = y > 0 ? y-1 : y
            let maxY = y < rows-1 ? y+1 : y
            let minX = x > 0 ? x-1 : x
            let maxX = x < cols-1 ? x+1 : x

            for ix in minX...maxX {
                for iy in minY...maxY {
                    if grid[iy][ix] == "." {
                        grid[iy][ix] = "#"
                        fillPoints.append((ix, iy))
                    }

                }
            }

        }

        return grid
    }

    private func fillGrid3(_ grid: [[Bool]]) -> [[Bool]] {
        var grid = grid
        let rows = grid.count
        let cols = grid[0].count

        // find a starting point inside the grid
        var x = 0
        let y = 1
        var seenEdge = false
        let row = grid[y]
        for i in 0..<cols {
            x = i
            let item = row[i]
            if item { seenEdge = true }
            else if seenEdge { break }
        }

        let startingPoint = (x, y)

        grid[startingPoint.1][startingPoint.0] = true

        var fillPoints: [(Int, Int)] = [startingPoint]

        while !fillPoints.isEmpty {
            let point = fillPoints.removeFirst()
            let x = point.0
            let y = point.1

            // check row above
            let minY = y > 0 ? y-1 : y
            let maxY = y < rows-1 ? y+1 : y
            let minX = x > 0 ? x-1 : x
            let maxX = x < cols-1 ? x+1 : x

            for ix in minX...maxX {
                for iy in minY...maxY {
                    if !grid[iy][ix] {
                        grid[iy][ix] = true
                        fillPoints.append((ix, iy))
                    }

                }
            }

        }

        return grid
    }

    private func fillGrid(_ grid: [[String]]) -> [[String]] {
        var grid = grid
        let cols = grid[0].count
        for y in 0..<grid.count {
            let row = grid[y]
            for x in 0..<cols-1 {
                let item = row[x]
                if item == "." {
                    
                    // is it inside the path?
                    // how many # does it cross to end of row?
                    var edges = 0
//                    for i in (x+1)..<cols {
//                        edges += row[i] == "#" ? 1 : 0
//                    }

                    var seenEdge = false

                    for i in (x+1)..<cols {
                        let spot = row[i]
                        if spot == "#" {
                            seenEdge = true
                        } else if seenEdge {
                            seenEdge = false
                            edges += 1
                        }
                    }

                    if seenEdge { edges += 1}



                    if edges % 2 != 0 {
                        grid[y][x] = "#"
                    }
                }
            }
        }
        return grid
    }

    private func buildGrid(_ planItems: [PlanItem]) -> [[String]] {
        var pathPoints: [(Int, Int)] = [(0,0)]

        var x = 0
        var y = 0
        var minX = 0
        var maxX = 0
        var minY = 0
        var maxY = 0

        for planItem in planItems {
            switch planItem.direction {
            case .up:
                (0..<planItem.meters).forEach { _ in
                    y = y-1
                    minY = min(minY, y)
                    pathPoints.append((x, y))
                }
            case .down:
                (0..<planItem.meters).forEach { _ in
                    y = y+1
                    maxY = max(maxY, y)
                    pathPoints.append((x, y))
                }
            case .left:
                (0..<planItem.meters).forEach { _ in
                    x = x-1
                    minX = min(minX, x)
                    pathPoints.append((x, y))
                }
            case .right:
                (0..<planItem.meters).forEach { _ in
                    x = x+1
                    maxX = max(maxX, x)
                    pathPoints.append((x, y))
                }
            }
        }

        let rows = maxY - minY + 1
        let cols = maxX - minX + 1
        var grid = Array(repeating: Array(repeating: ".", count: cols), count: rows)

        for point in pathPoints {
            let x = point.0 - minX
            let y = point.1 - minY

            grid[y][x] = "#"
        }

        return grid
    }

    private func buildGrid2(_ planItems: [PlanItem]) -> [[Bool]] {
        var pathPoints: [(Int, Int)] = [(0,0)]

        var x = 0
        var y = 0
        var minX = 0
        var maxX = 0
        var minY = 0
        var maxY = 0

        for planItem in planItems {
            switch planItem.direction {
            case .up:
                (0..<planItem.meters).forEach { _ in
                    y = y-1
                    minY = min(minY, y)
                    pathPoints.append((x, y))
                }
            case .down:
                (0..<planItem.meters).forEach { _ in
                    y = y+1
                    maxY = max(maxY, y)
                    pathPoints.append((x, y))
                }
            case .left:
                (0..<planItem.meters).forEach { _ in
                    x = x-1
                    minX = min(minX, x)
                    pathPoints.append((x, y))
                }
            case .right:
                (0..<planItem.meters).forEach { _ in
                    x = x+1
                    maxX = max(maxX, x)
                    pathPoints.append((x, y))
                }
            }
        }

        let rows = maxY - minY + 1
        let cols = maxX - minX + 1
        var grid = Array(repeating: Array(repeating: false, count: cols), count: rows)

        for point in pathPoints {
            let x = point.0 - minX
            let y = point.1 - minY

            grid[y][x] = true
        }

        return grid
    }

    private func mapPlan(_ lines: [Substring]) -> [PlanItem] {
        return lines.compactMap { line in
            let split = line.split(separator: " ")
            let direction = String(split[0])
            let length = Int(String(split[1]))!
            var hexColor = split[2]
            hexColor.removeFirst()
            hexColor.removeFirst()
            hexColor.removeLast()

            var rgbValue:UInt64 = 0
            Scanner(string: String(hexColor)).scanHexInt64(&rgbValue)
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

            switch direction {
            case "U":
                return PlanItem(direction: .up, meters: length, hex: String(hexColor), r: red, g: green, b: blue)
            case "D":
                return PlanItem(direction: .down, meters: length, hex: String(hexColor), r: red, g: green, b: blue)
            case "L":
                return PlanItem(direction: .left, meters: length, hex: String(hexColor), r: red, g: green, b: blue)
            case "R":
                return PlanItem(direction: .right, meters: length, hex: String(hexColor), r: red, g: green, b: blue)
            default:
                return nil
            }
        }
    }

    private func mapPlan2(_ lines: [Substring]) -> [PlanItem] {
        return lines.compactMap { line in
            let split = line.split(separator: " ")
            //let direction = String(split[0])
            //let length = Int(String(split[1]))!
            var hexColor = split[2]
            hexColor.removeFirst()
            hexColor.removeFirst()
            hexColor.removeLast()

            let firstFive = hexColor.prefix(5)
            let last = hexColor.last!

            var rgbValue:UInt64 = 0
            Scanner(string: String(firstFive)).scanHexInt64(&rgbValue)
//            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
//            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
//            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

            switch last {
            case "3":
                return PlanItem(direction: .up, meters: Int(rgbValue), hex: String(hexColor), r: 0, g: 0, b: 0)
            case "1":
                return PlanItem(direction: .down, meters: Int(rgbValue), hex: String(hexColor), r: 0, g: 0, b: 0)
            case "2":
                return PlanItem(direction: .left, meters: Int(rgbValue), hex: String(hexColor), r: 0, g: 0, b: 0)
            case "0":
                return PlanItem(direction: .right, meters: Int(rgbValue), hex: String(hexColor), r: 0, g: 0, b: 0)
            default:
                return nil
            }
        }
    }

    struct PlanItem {
        enum Direction {
            case up, down, left, right
        }

        let direction: Direction
        let meters: Int

        let hex: String
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
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

}
