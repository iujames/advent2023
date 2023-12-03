import Algorithms

struct Day02: AdventDay {
    var data: String

    func part1() -> Any {

        let games = data.split(separator: "\n").compactMap { line -> Game? in
            let headerSplit = line.split(separator: ":")
            let header = headerSplit[0]
            let gameIDString = header.split(separator: " ")[1]
            guard let gameID = Int(String(gameIDString)) else { return nil }
            var game = Game(id: gameID)
            let values = headerSplit[1]
            game.pulls = values.split(separator: ";").compactMap { pull in
                // comma sep list of pulls "3 blue"
                var gamePull = Game.Pull(blue: 0, red: 0, green: 0)
                pull.split(separator: ",").forEach { gameItem in
                    let gameSplit = gameItem.split(separator: " ")
                    if let value = Int(gameSplit[0]) {
                        switch gameSplit[1] {
                        case "blue": gamePull.blue += value
                        case "green": gamePull.green += value
                        case "red": gamePull.red += value
                        default:
                            break
                        }
                    }
                }
                return gamePull
            }

            return game
        }

        let maxRed = 12
        let maxGreen = 13
        let maxBlue = 14

        let possibleGames = games.filter {
            $0.pulls.allSatisfy {
                $0.red <= maxRed && $0.green <= maxGreen && $0.blue <= maxBlue
            }
        }

        return possibleGames.map { $0.id }.reduce(0, +)
    }

    func part2() -> Any {

        let games = data.split(separator: "\n").compactMap { line -> Game? in
            let headerSplit = line.split(separator: ":")
            let header = headerSplit[0]
            let gameIDString = header.split(separator: " ")[1]
            guard let gameID = Int(String(gameIDString)) else { return nil }
            var game = Game(id: gameID)
            let values = headerSplit[1]
            game.pulls = values.split(separator: ";").compactMap { pull in
                // comma sep list of pulls "3 blue"
                var gamePull = Game.Pull(blue: 0, red: 0, green: 0)
                pull.split(separator: ",").forEach { gameItem in
                    let gameSplit = gameItem.split(separator: " ")
                    if let value = Int(gameSplit[0]) {
                        switch gameSplit[1] {
                        case "blue": gamePull.blue += value
                        case "green": gamePull.green += value
                        case "red": gamePull.red += value
                        default:
                            break
                        }
                    }
                }
                return gamePull
            }

            return game
        }

        let gameMins = games.compactMap { game -> Game.Pull? in
            guard let minBlue = game.pulls.map({ $0.blue }).max(),
                  let minRed = game.pulls.map({ $0.red }).max(),
                  let minGreen = game.pulls.map({ $0.green }).max() else {
                return nil
            }

            return Game.Pull(blue: minBlue, red: minRed, green: minGreen)
        }

        let powers = gameMins.map { gameMin in
            gameMin.red * gameMin.green * gameMin.blue
        }

        return powers.reduce(0, +)
    }

    struct Game {
        let id: Int
        var pulls: [Pull] = []

        struct Pull {
            var blue: Int
            var red: Int
            var green: Int
        }
    }
}
