class ScoreCalculator {

    private(set) var score: Int = 0
    private var scoreForThisShot: Int = 0
    private var numberOfObstaclesHitDuringThisShot: Int = 0

    func destroy(obstacleBody: ObstacleBody, orangeObstaclesCount: Int) {
        numberOfObstaclesHitDuringThisShot += 1
        scoreForThisShot += getMultiplier(orangeObstaclesCount: orangeObstaclesCount) * getBaseScore(for: obstacleBody)
    }

    func getMultiplier(orangeObstaclesCount: Int) -> Int {
        if orangeObstaclesCount <= 0 {
            return 100
        } else if 1...3 ~= orangeObstaclesCount {
            return 10
        } else if 4...7 ~= orangeObstaclesCount {
            return 5
        } else if 8...10 ~= orangeObstaclesCount {
            return 3
        } else if 11...15 ~= orangeObstaclesCount {
            return 2
        } else {
            return 1
        }
    }

    private func getBaseScore(for obstacleBody: ObstacleBody) -> Int {
        switch obstacleBody.colour {
        case .blue, .green:
            return 10
        case .orange:
            return 100
        default:
            assert(false, "Cannot identify obstacle colour to return base score in score calculator")
        }
    }

    func updateScore(orangeObstaclesCount: Int) {
        score += scoreForThisShot * numberOfObstaclesHitDuringThisShot
        scoreForThisShot = 0
        numberOfObstaclesHitDuringThisShot = 0
    }
}
