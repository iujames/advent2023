import Algorithms
import CoreGraphics

struct Day05: AdventDay {
    var data: String
    var lines: [Substring] {
        data.split(separator: "\n", omittingEmptySubsequences: false)
    }

    func part1() -> Any {

        let seeds = String(lines[0]).split(separator: ":")[1].trimmingCharacters(in: .whitespaces).split(separator: " ").map { Int($0)! }

        var index = 3 // start line index of maps

        let seedToSoil = parseNextMap(startIndex: index, lines: lines)
        index = index + seedToSoil.sources.count + 2

        let soilToFertilizer = parseNextMap(startIndex: index, lines: lines)
        index = index + soilToFertilizer.sources.count + 2

        let fertilizerToWater = parseNextMap(startIndex: index, lines: lines)
        index = index + fertilizerToWater.sources.count + 2

        let waterToLight = parseNextMap(startIndex: index, lines: lines)
        index = index + waterToLight.sources.count + 2

        let lightToTemperature = parseNextMap(startIndex: index, lines: lines)
        index = index + lightToTemperature.sources.count + 2

        let temperatureToHumidity = parseNextMap(startIndex: index, lines: lines)
        index = index + temperatureToHumidity.sources.count + 2

        let humidityToLocation = parseNextMap(startIndex: index, lines: lines)

        let locations = seeds.map {
            humidityToLocation.mapSource(
                temperatureToHumidity.mapSource(
                    lightToTemperature.mapSource(
                        waterToLight.mapSource(
                            fertilizerToWater.mapSource(
                                soilToFertilizer.mapSource(
                                    seedToSoil.mapSource($0)
                                )
                            )
                        )
                    )
                )
            )
        }

        return locations.min()!
    }

    func part2() -> Any {

        let seedInfo = String(lines[0]).split(separator: ":")[1].trimmingCharacters(in: .whitespaces).split(separator: " ").map { Int($0)! }

        var seedRangeStart: [Int] = []
        var seedRangeLength: [Int] = []

        for i in 0..<(seedInfo.count/2) {
            seedRangeStart.append(seedInfo[i*2])
            seedRangeLength.append(seedInfo[i*2 + 1])
        }

        var index = 3 // start line index of maps

        let seedToSoil = parseNextMap(startIndex: index, lines: lines)
        index = index + seedToSoil.sources.count + 2

        let soilToFertilizer = parseNextMap(startIndex: index, lines: lines)
        index = index + soilToFertilizer.sources.count + 2

        let fertilizerToWater = parseNextMap(startIndex: index, lines: lines)
        index = index + fertilizerToWater.sources.count + 2

        let waterToLight = parseNextMap(startIndex: index, lines: lines)
        index = index + waterToLight.sources.count + 2

        let lightToTemperature = parseNextMap(startIndex: index, lines: lines)
        index = index + lightToTemperature.sources.count + 2

        let temperatureToHumidity = parseNextMap(startIndex: index, lines: lines)
        index = index + temperatureToHumidity.sources.count + 2

        let humidityToLocation = parseNextMap(startIndex: index, lines: lines)

        // work backwards through locations, smallest to largest, until a seed match is found

        var location: Int = 0
        var found = false

        while !found {
            let humidity = humidityToLocation.mapDestination(location)
            let temperature = temperatureToHumidity.mapDestination(humidity)
            let light = lightToTemperature.mapDestination(temperature)
            let water = waterToLight.mapDestination(light)
            let fertilizer = fertilizerToWater.mapDestination(water)
            let soil = soilToFertilizer.mapDestination(fertilizer)
            let mappedSeed = seedToSoil.mapDestination(soil)

            // is this seed in a valid range?
            for x in 0..<seedRangeStart.count {
                let rangeMin = seedRangeStart[x]
                let length = seedRangeLength[x]
                let rangeMax = rangeMin + length

                if mappedSeed >= rangeMin && mappedSeed < rangeMax {
                    found = true
                    break
                }
            }

            if !found {
                location += 1
            }
        }

        return location
    }

    private func parseNextMap(startIndex: Int, lines: [Substring]) -> MapInfo {
        var mapInfo = MapInfo()
        for i in startIndex..<lines.count {
            let line = String(lines[i])
            if line.trimmingCharacters(in: .whitespaces).isEmpty { return mapInfo } // end of section

            let values = line.split(separator: " ").map { Int($0)! }
            mapInfo.destinations.append(values[0])
            mapInfo.sources.append(values[1])
            mapInfo.lengths.append(values[2])
        }
        return mapInfo // end of file
    }

    private struct MapInfo {
        var sources: [Int] = []
        var destinations: [Int] = []
        var lengths: [Int] = []

        func mapSource(_ value: Int) -> Int {
            
            for i in 0..<sources.count {
                let source = sources[i]
                let length = lengths[i]

                let offset = value - source
                if offset >= 0 && offset < length {
                    return destinations[i] + offset
                }
            }

            return value // unmapped
        }

        func mapDestination(_ value: Int) -> Int {

            for i in 0..<destinations.count {
                let destination = destinations[i]
                let length = lengths[i]

                let offset = value - destination
                if offset >= 0 && offset < length {
                    return sources[i] + offset
                }
            }

            return value // unmapped
        }
    }
}
