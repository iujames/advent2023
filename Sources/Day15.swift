import Algorithms


struct Day15: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n")
    }

    func part1() -> Any {
        return lines[0]
            .split(separator: ",")
            .map { String($0).compactMap { $0.asciiValue }}
            .map { Day15.score($0) }
            .reduce(0, +)
    }

    func part2() -> Any {

        let steps = lines[0].split(separator: ",").map { String($0) } // .compactMap { $0.asciiValue }.map { Int($0) }}
        // steps is [String]

        let lenses = steps.map { Lens(code: $0)}

        var boxes = Array(repeating: [Lens](), count: 256)

        // process lenses into boxes...
        for lens in lenses {
            if let focalLength = lens.focalLength {
                // its an add
                var box = boxes[lens.box]
                if let index = box.firstIndex(where: { $0.label == lens.label }) {
                    // replace it
                    box[index] = lens
                } else {
                    //add to end
                    box.append(lens)
                }
                boxes[lens.box] = box
            } else {
                // its a remove
                var box = boxes[lens.box]
                box.removeAll { $0.label == lens.label }
                boxes[lens.box] = box
            }
        }

        // compute total focusing power by looping over boxes and lenses within
        var power = 0
        for boxIndex in 0..<boxes.count {
            let box = boxes[boxIndex]

            for lensIndex in 0..<box.count {
                let lensValue = (1+boxIndex) * (lensIndex+1) * box[lensIndex].focalLength!
                power += lensValue
            }
        }

        return power
    }

    struct Lens {
        let box: Int
        let label: String
        let focalLength: Int? // nil means its a removal

        init(code: String) {
            if code.last == "-" {
                // removal
                label = String(code.prefix(code.count - 1))
                box = Day15.score(label.compactMap { $0.asciiValue })
                focalLength = nil
            } else {
                let split = code.split(separator: "=")
                label = String(split[0])
                box = Day15.score(label.compactMap { $0.asciiValue })
                focalLength = Int(split[1])!
            }
        }
    }

    private static func score(_ items: [UInt8]) -> Int {
        var value = 0
        for i in 0..<items.count {
            let current = items[i]
            value += Int(current)
            value *= 17
            value = value % 256
        }
        return value
    }

}
