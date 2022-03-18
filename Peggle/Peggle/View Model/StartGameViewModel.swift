import Foundation

class StartGameViewModel: CanvasViewModel {

    private let startingCannonballNumber = 10

    private weak var viewModelDelegate: StartGameViewModelDelegate?
    private var audioPlayer = StartGameAudioPlayer()

    @Published private(set) var cannonRotation: Double = .zero
    @Published private(set) var level: Level
    @Published private(set) var bucket: Bucket = Bucket(coordinate: .zero)
    @Published var gameIsWon = false
    @Published var gameIsLost = false
    @Published var justExploded = false
    @Published var kaboomMessageTimer = 0

    private(set) var powerup: Powerup
    private(set) var cannonPosition: Point
    private var cannonballsInPlay: [Cannonball] = []
    private var cannonCurrentlyFacing: Point
    private var pegEngine: PegEngine
    private var gameBounds: Rect
    private var rangeOfRenderedGameObjects: Range<Int> {
        0 ..< pegEngine.countOfRenderedGameObjects
    }

    init(level: Level = .init(), gameBounds: Rect = .zero, powerup: Powerup = .spooky) {
        self.level = level
        self.gameBounds = gameBounds
        self.powerup = powerup
        self.pegEngine = PegEngine(level: level, gameBounds: gameBounds, cannonballsLeft: startingCannonballNumber)
        self.cannonPosition = Point(xCoord: gameBounds.midX, yCoord: gameBounds.minY + Cannonball().diameter)
        self.cannonCurrentlyFacing = Point(xCoord: gameBounds.maxX, yCoord: gameBounds.minY)
    }

    func setDelegate(viewModelDelegate: StartGameViewModelDelegate) {
        self.viewModelDelegate = viewModelDelegate
    }

    func startGame() {
        audioPlayer.startgame()
        bucket.moveObject(to: Point(xCoord: gameBounds.midX, yCoord: gameBounds.maxY - (bucket.height / 2)))
        pegEngine.addGameObjectAsPKPhysicsBody(gameObject: bucket, locationTouched: nil)
        pegEngine.setUpdateDelegate(as: self)
        pegEngine.startGame(withPowerup: powerup)
    }

    override var levelGameObjects: [GameObject] {
        level.getGameObjects()
    }

    override var cannonballs: [Cannonball] {
        cannonballsInPlay
    }

    var orangeObstaclesLeft: Int {
        pegEngine.orangeObstaclesLeft
    }

    var spookyBallsLeft: Int {
        pegEngine.spookyBallsLeft
    }

    var score: Int {
        pegEngine.score
    }

    var multiplier: Int {
        pegEngine.multiplier
    }

    private var gameObjectsInPlay: [GameObject] {
        var gameObjects: [GameObject] = []
        gameObjects.append(bucket)
        gameObjects.append(contentsOf: cannonballsInPlay)
        gameObjects.append(contentsOf: levelGameObjects)
        return gameObjects
    }

    var cannonballsLeft: Int {
        pegEngine.cannonballsLeft
    }

    private func moveGameObject(_ gameObject: GameObject, to coordinate: Point) {
        gameObject.moveObject(to: coordinate)
    }

    override func backgroundOnTapGesture(at coord: Point) {
        shootCannonball()
    }

    private func shootCannonball() {
        guard cannonballs.count == 0 else {
            return
        }

        didShootCannonball()

        let newCannonball = Cannonball(coordinate: Point(xCoord: gameBounds.midX, yCoord: gameBounds.minY))
        newCannonball.moveObject(to: Point(xCoord: newCannonball.coordinate.xCoord,
                                           yCoord: newCannonball.coordinate.yCoord + newCannonball.diameter))
        cannonballsInPlay.append(newCannonball)
        pegEngine.shootCannonball(gameObject: newCannonball, locationTouched: cannonCurrentlyFacing)
    }

    override func backgroundOnDragGesture(_ coord: Point) {
        rotateCannonTowards(locationTouched: coord)
    }

    override func obstacleOnDragGesture(obstacle: Obstacle?, coord: Point) {
        rotateCannonTowards(locationTouched: coord)
    }

    private func rotateCannonTowards(locationTouched: Point) {
        let arbitraryPositiveXDirection = 1.0
          let axisVector = Point(xCoord: cannonPosition.xCoord + arbitraryPositiveXDirection,
                                 yCoord: cannonPosition.yCoord)
            .subtract(cannonPosition)
        let touchVector = Point(xCoord: locationTouched.xCoord, yCoord: locationTouched.yCoord)
            .subtract(cannonPosition)
        let angleInRadians = axisVector.getAngleInRadians(with: touchVector)
        cannonCurrentlyFacing = locationTouched
        cannonRotation = angleInRadians
    }

    func endGame() {
        audioPlayer.endGame()
        pegEngine.resetWillBeDestroyedStatusOfObstacles()
        viewModelDelegate?.didEndGame()
    }

    func processWinLoseConditions() {
        pegEngine.processWinCondition()
        pegEngine.processLoseCondition()

        if !gameIsWon {
            pegEngine.updateScore(orangeObstaclesCount: orangeObstaclesLeft)
            didLoseGame()
        }
    }
}

extension StartGameViewModel: PegEngineUpdateDelegate {

    func didUpdatePegEngine() {
        let renderedGameObjects = pegEngine.renderedGameObjects
        for gameObject in gameObjectsInPlay {
            guard let renderedGameObject = renderedGameObjects.first(where: { $0 === gameObject }) else {
                removeGameObject(gameObject)
                return
            }
            objectWillChange.send()
            moveGameObject(gameObject, to: renderedGameObject.coordinate)
        }
    }

    private func removeGameObject(_ gameObject: GameObject) {
        if let cannonball = gameObject as? Cannonball {
            cannonballsInPlay.removeAll(where: { $0 ==  cannonball })
        } else if let obstacle = gameObject as? Obstacle {
            level.removeGameObject(obstacle)
        } else {
            assert(false, "Attempting to remove a Game Object in StartGameViewModel that cannot be identified")
        }
    }

    func didAddNewGameObject(_ gameObject: GameObject) {
        if let cannonball = gameObject as? Cannonball {
            cannonballsInPlay.append(cannonball)
        } else {
            level.addGameObject(gameObject)
        }
    }

    func didWinGame() {
        gameIsWon = true
    }

    func didLoseGame() {
        gameIsLost = true
    }

    func didExplode() {
        audioPlayer.explode()
        justExploded = true
        kaboomMessageTimer = 2
    }

    func didSpookyball() {
        audioPlayer.spookyball()
    }

    func didFreeBall() {
        audioPlayer.freeBall()
    }

    func didShootCannonball() {
        audioPlayer.shootCannonball()
    }
}
