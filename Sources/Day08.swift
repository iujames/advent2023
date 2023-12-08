import Algorithms

struct Day08: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        var lines = lines
        let instructions = Array(lines[0])
        lines.removeFirst()

        var lookup: [String: Node] = [:]

        lines.forEach { line in
            let lineSplit = line.split(separator: " = ")
            let key = lineSplit[0]
            let valuesSplit = lineSplit[1].split(separator: ", ")
            var left = valuesSplit[0]
            var right = valuesSplit[1]
            left.removeFirst()
            right.removeLast()

            let node = Node(key: String(key), left: String(left), right: String(right))
            lookup[node.key] = node
        }

        var step = 0
        var found = false
        var node = lookup["AAA"]!

        while !found {
            let index = step % instructions.count
            let move = instructions[index]
            step += 1

            if move == "L" {
                node = lookup[node.left]!
            } else {
                node = lookup[node.right]!
            }

            found = node.key == "ZZZ"
        }

        return step
    }

    func part2() -> Any {
        var lines = lines
        let instructions = Array(lines[0])
        lines.removeFirst()

        var lookup: [String: Node] = [:]
        var currentNodes: [Node] = []

        lines.forEach { line in
            let lineSplit = line.split(separator: " = ")
            let key = lineSplit[0]
            let valuesSplit = lineSplit[1].split(separator: ", ")
            var left = valuesSplit[0]
            var right = valuesSplit[1]
            left.removeFirst()
            right.removeLast()

            let node = Node(key: String(key), left: String(left), right: String(right))
            lookup[node.key] = node

            if node.key.last == "A" {
                currentNodes.append(node)
            }
        }

        var lengths = currentNodes.map { node in

            var node = node
            var step = 0
            var found = false

            while !found {
                let index = step % instructions.count
                let move = instructions[index]
                step += 1

                if move == "L" {
                    node = lookup[node.left]!
                } else {
                    node = lookup[node.right]!
                }

                found = node.key.last == "Z"
            }

            return step

        }

        let first = lengths.removeFirst()
        return lengths.reduce(first) { result, next in findLCM(n1: result, n2: next)}
    }

    struct Node {
        let key: String
        let left: String
        let right: String
    }

    // Function to find gcd of two numbers
    func findGCD(_ num1: Int, _ num2: Int) -> Int {
       var x = 0

       // Finding maximum number
       var y: Int = max(num1, num2)

       // Finding minimum number
       var z: Int = min(num1, num2)

       while z != 0 {
          x = y
          y = z
          z = x % y
        }
       return y
    }

    // Function to find lcm of two numbers
    func findLCM(n1: Int, n2: Int)->Int{
       return (n1 * n2/findGCD(n1, n2))
    }
}
