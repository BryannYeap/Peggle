import QuartzCore

class GameLoop {

    static var count = 0
    private let framesPerSecond: Double
    private let updateRate: Double

    private var displayLink: CADisplayLink?
    private var previousUpdateTime: Double
    private var lag: Double

    weak var gameEngine: GameEngine?

    init(framesPerSecond: Double = 60.0) {
        self.framesPerSecond = framesPerSecond
        self.updateRate = 1.0 / framesPerSecond
        self.previousUpdateTime = CACurrentMediaTime()
        self.lag = 0
    }

    func setGameEngine(as gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func startGameLoop() {
        previousUpdateTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
    }

    @objc private func step() {
        let currentUpdateTime: Double = CACurrentMediaTime()
        let elapsed: Double = currentUpdateTime - previousUpdateTime
        previousUpdateTime = currentUpdateTime
        lag += elapsed

        while lag >= updateRate {
            gameEngine?.update(updateRate)
            lag -= updateRate
        }

        gameEngine?.render(lag: lag)
    }
}
