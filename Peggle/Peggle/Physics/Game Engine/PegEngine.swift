class PegEngine: GameEngine {

    internal var gameLoop: GameLoop = GameLoop(framesPerSecond: 120.0)

    weak var pegEngineUpdateDelate: PegEngineUpdateDelegate?

    private var physicsWorld: PKPhysicsWorld
    private var renderer = GameRenderer()
    private var scoreCalculator = ScoreCalculator()
    private var bucketBody: BucketBody?
    private var powerup: Powerup?
    private var kaboomIsActive: Bool = false

    private(set) var cannonballsLeft: Int
    private(set) var orangeObstaclesLeft: Int = 0
    private(set) var spookyBallsLeft: Int = 0

    private let defaultRestitution: Double = 0.85
    private let cannonballShootingVelocityMagnitude = 700.0
    private let kaboomVelocityMagnitude: Double = 2100.0
    private let kaboomBlastRadius = 125.0
    private let powerupColour: Colour = .green
    private let gameBounds: Rect

    init(level: Level = .init(), gameBounds: Rect = .zero, cannonballsLeft: Int = 10) {
        self.gameBounds = gameBounds
        self.physicsWorld = PKPhysicsWorld(physicsBodies: [], worldBounds: gameBounds)
        self.cannonballsLeft = cannonballsLeft
        gameLoop.setGameEngine(as: self)
        fillPhysicsWorld(with: level)
        physicsWorld.setUpdateDelegate(as: self)
    }

    var renderedGameObjects: [GameObject] {
        Array(renderer.gameObjectToPhysicsBodiesMap.keys)
    }

    var countOfRenderedGameObjects: Int {
        renderer.gameObjectToPhysicsBodiesMap.count
    }

    var cannonballsInPlay: [PKPhysicsBody] {
        physicsWorld.physicsBodies.filter({ $0 is CannonballBody }).map({
            if let cannonball = $0 as? CannonballBody {
                return cannonball
            }
            assert(false, "Every item after filtered should be cannonball body")
        })
    }

    var score: Int {
        scoreCalculator.score
    }

    var multiplier: Int {
        scoreCalculator.getMultiplier(orangeObstaclesCount: orangeObstaclesLeft)
    }

    var noSpookyBalls: Bool {
        spookyBallsLeft <= 0
    }

    func addGameObjectAsPKPhysicsBody(gameObject: GameObject, locationTouched: Point?) {
        let newPhysicsBody = createPhysicsBody(gameObject: gameObject, locationTouched: locationTouched)
        physicsWorld.addPhysicsBody(newPhysicsBody)
        renderer.map(gameObject: gameObject, toPhysicsBody: newPhysicsBody)
    }

    func setUpdateDelegate(as updateDelegate: PegEngineUpdateDelegate) {
        self.pegEngineUpdateDelate = updateDelegate
    }

    private func fillPhysicsWorld(with level: Level) {
        let gameObjects = level.getGameObjects()
        for gameObject in gameObjects {
            let newPhysicsBody = createPhysicsBody(gameObject: gameObject, locationTouched: nil)
            physicsWorld.addPhysicsBody(newPhysicsBody)
            renderer.map(gameObject: gameObject, toPhysicsBody: newPhysicsBody)
        }
    }

    private func createPhysicsBody(gameObject: GameObject, locationTouched: Point?) -> PKPhysicsBody {
        if let bucket =  gameObject as? Bucket {
            let newBucket = createBucketBody(withBucket: bucket)
            bucketBody = newBucket
            return newBucket
        } else if let cannonball = gameObject as? Cannonball, let positionToEndUp = locationTouched {
            return createCannonballBody(withCannonball: cannonball, towards: positionToEndUp)
        } else if let peg = gameObject as? PegObstacle {
            return createPegBody(withPeg: peg)
        } else if let triangle = gameObject as? TriangleObstacle {
            return createTriangleBody(withTriangle: triangle)
        } else {
            assert(false, "Cannot determine GameObject that is attempting to be created in PegEngine")
        }
    }

    private func createBucketBody(withBucket bucket: Bucket) -> BucketBody {
        return BucketBody(isOscillatableAndSpringConstant: (false, nil),
                          isDynamic: false,
                          restitution: 1.0,
                          velocity: Vector(xChange: 250, yChange: 0),
                          position: bucket.coordinate,
                          width: bucket.width,
                          height: bucket.height)
    }

    private func createCannonballBody(withCannonball cannonball: Cannonball,
                                      towards positionToEndUp: Point) -> CannonballBody {
        let relativeVelocity = positionToEndUp.subtract(cannonball.coordinate)
        let normalisedVelocity = relativeVelocity.tryToGetUnitVector()
        let velocity = normalisedVelocity.scalarMultiply(with: cannonballShootingVelocityMagnitude)
        return CannonballBody(isOscillatableAndSpringConstant: (false, nil),
                              isDynamic: true,
                              mass: 50.0,
                              restitution: defaultRestitution,
                              velocity: velocity,
                              position: cannonball.coordinate,
                              radius: cannonball.radius)
    }

    private func createPegBody(withPeg peg: PegObstacle) -> PegBody {
        var pegColour: Colour?
        if peg is PegBlue {
            pegColour = Colour.blue
        } else if peg is PegOrange {
            pegColour = Colour.orange
            orangeObstaclesLeft += 1
        } else if peg is PegGreen {
            pegColour = Colour.green
        } else {
            assert(false, "Attempting to create PKPhysicsBody for an unidentifiable peg colour in PegEngine")
        }
        return PegBody(isOscillatableAndSpringConstant: (false, nil),
                       colour: pegColour ?? Colour.blue,
                       isDynamic: false,
                       restitution: defaultRestitution,
                       position: peg.coordinate,
                       radius: peg.radius)
    }

    private func createTriangleBody(withTriangle triangle: TriangleObstacle) -> TriangleBody {
        let isOscillatable = triangle.isOscillatable
        var springConstant: Double?
        if isOscillatable {
            springConstant = triangle.oscillatingSpringConstant
        }

        var triangleColour: Colour?
        if triangle is TriangleBlue {
            triangleColour = Colour.blue
        } else if triangle is TriangleOrange {
            triangleColour = Colour.orange
            orangeObstaclesLeft += 1
        } else if triangle is TriangleGreen {
            triangleColour = Colour.green
        } else if triangle is TriangleRed {
            triangleColour = Colour.red
        } else {
            assert(false, "Attempting to create PKPhysicsBody for an unidentifiable peg colour in PegEngine")
        }
        return TriangleBody(isOscillatableAndSpringConstant: (isOscillatable, springConstant),
                            colour: triangleColour ?? Colour.blue,
                            isBlock: triangle.isBlock,
                            isDynamic: false,
                            mass: isOscillatable ? 50.0 : Double.greatestFiniteMagnitude,
                            restitution: defaultRestitution,
                            position: triangle.coordinate,
                            firstEdge: triangle.firstEdge,
                            secondEdge: triangle.secondEdge,
                            thirdEdge: triangle.thirdEdge)
    }

    func startGame(withPowerup powerup: Powerup) {
        self.powerup = powerup
        gameLoop.startGameLoop()
    }

    func shootCannonball(gameObject: GameObject, locationTouched: Point) {
        resetCollisionCountersOfObstacleBodies()
        addGameObjectAsPKPhysicsBody(gameObject: gameObject, locationTouched: locationTouched)
    }

    private func resetCollisionCountersOfObstacleBodies() {
        for physicsBody in physicsWorld.physicsBodies {
            if let obstacleBody = physicsBody as? ObstacleBody {
                obstacleBody.resetCollisionCounter()
            }
        }
    }

    func update(_ timeInterval: Double) {
        physicsWorld.simulatePhysics(timeInterval)
        processBucketBody()
        processWinCondition()
        processLoseCondition()
        pegEngineUpdateDelate?.didUpdatePegEngine()
    }

    private func processBucketBody() {
        guard let bucketBody = bucketBody else {
            return
        }

        for physicsBody in physicsWorld.physicsBodies {
            if !physicsBody.isDestroyed &&
                bucketBody.containsBody(physicsBody: physicsBody) {
                    if let cannonball = physicsBody as? CannonballBody {
                        cannonball.destroyThisBody()
                        didDestroyOutOfBoundBody(outOfBoundBody: cannonball)
                        addFreeBall()
                        return
                    }
            }
        }
    }

    private func addFreeBall() {
        if noSpookyBalls {
            pegEngineUpdateDelate?.didFreeBall()
            cannonballsLeft += 1
        }
    }

    func render(lag: Double) {
        renderer.render(lag: lag)
    }

    func processWinCondition() {
        guard orangeObstaclesLeft == 0 else {
            return
        }
        updateScore(orangeObstaclesCount: orangeObstaclesLeft)
        pegEngineUpdateDelate?.didWinGame()
    }

    func processLoseCondition() {
        guard noCannonballsInPlay() && noCannonballsLeft() else {
            return
        }
        updateScore(orangeObstaclesCount: orangeObstaclesLeft)
        pegEngineUpdateDelate?.didLoseGame()
    }

    func updateScore(orangeObstaclesCount: Int) {
        scoreCalculator.updateScore(orangeObstaclesCount: orangeObstaclesLeft)
    }

    private func noCannonballsInPlay() -> Bool {
        cannonballsInPlay.count <= 0
    }

    private func noCannonballsLeft() -> Bool {
        return cannonballsLeft <= 0
    }

    func resetWillBeDestroyedStatusOfObstacles() {
        for physicsBody in physicsWorld.physicsBodies {
            if let obstacleBody = physicsBody as? ObstacleBody {
                obstacleBody.setWillBeDestroyedStatus(as: false)
            }
        }
    }
}

extension PegEngine: PKPhysicsWorldUpdateDelegate {

    func didDestroyOutOfBoundBody(outOfBoundBody: PKPhysicsBody) {
        if noSpookyBalls {
            updateScore(orangeObstaclesCount: orangeObstaclesLeft)
            destroyAllCollidedPegs()
        }

        if let cannonball = outOfBoundBody as? CannonballBody {
            if spookyBallsLeft > 0 {
                processSpookyBall(spookyBall: cannonball)
                spookyBallsLeft -= 1
            } else {
                cannonballsLeft -= 1
            }
        }
    }

    private func processSpookyBall(spookyBall cannonball: CannonballBody) {
        guard powerup == .spooky else {
            return
        }

        let pointOfShooting = Point(xCoord: cannonball.position.xCoord, yCoord: gameBounds.minY)
        let newCannonball = Cannonball(coordinate: pointOfShooting)
        let target = pointOfShooting.add(vector: cannonball.velocity)
        shootCannonball(gameObject: newCannonball, locationTouched: target)
        pegEngineUpdateDelate?.didAddNewGameObject(newCannonball)
    }

    private func destroyAllCollidedPegs() {
        for physicsBody in physicsWorld.physicsBodies {
            if let obstacleBody = physicsBody as? ObstacleBody {
                if obstacleBody.willBeDestroyed {
                    obstacleBody.destroyThisBody()
                }
            }
        }
    }

    func collisionDidOccur(physicsBody: PKPhysicsBody, newVelocity: Vector) {
        if physicsBody.isOscillatable, let oscillatableBody = physicsBody.oscillatableBody {
            oscillatableBody.oscillate(withVelocity: newVelocity)
        }
    }

    func collisionDidOccur(physicsBodies: PKPhysicsBody...) {
        for physicsBody in physicsBodies {
            if let obstacleBody = physicsBody as? ObstacleBody {
                proccessObstacleBody(obstacleBody)
            }
        }
    }

    private func proccessObstacleBody(_ obstacleBody: ObstacleBody) {

        if obstacleBody.colour == powerupColour && !obstacleBody.willBeDestroyed {
            activatePowerup(from: obstacleBody)
        }

        if obstacleBody.isBlockingCannonball {
            obstacleBody.destroyThisBody()
        }

        setAsWillBeDestroyed(obstacleBody: obstacleBody)
        obstacleBody.incrementCollisionCounter()
    }

    private func setAsWillBeDestroyed(obstacleBody: ObstacleBody) {
        guard !obstacleBody.willBeDestroyed && !obstacleBody.isBlock else {
            return
        }

        obstacleBody.setWillBeDestroyedStatus(as: true)
        scoreCalculator.destroy(obstacleBody: obstacleBody, orangeObstaclesCount: orangeObstaclesLeft)

        if obstacleBody.colour == .orange {
            orangeObstaclesLeft -= 1
        }
    }

    private func activatePowerup(from obstacleBody: ObstacleBody) {
        switch powerup {
        case .spooky:
            activateSpookyBall()
        case .kaboom:
            activateKaboom(from: obstacleBody)
        default:
            assert(false, "Powerup cannot be identified")
        }
    }

    private func activateSpookyBall() {
        pegEngineUpdateDelate?.didSpookyball()
        spookyBallsLeft += 1
    }

    private func activateKaboom(from powerupObstacle: ObstacleBody) {
        pegEngineUpdateDelate?.didExplode()
        explode(powerupObstacle: powerupObstacle)
    }

    private func explode(powerupObstacle: ObstacleBody) {
        setAsWillBeDestroyed(obstacleBody: powerupObstacle)
        for physicsBody in physicsWorld.physicsBodies where physicsBody !== powerupObstacle
            && physicsBody.isWithin(distance: kaboomBlastRadius, of: powerupObstacle.position) {

            if let obstacleBody = physicsBody as? ObstacleBody, !obstacleBody.willBeDestroyed {
                setAsWillBeDestroyed(obstacleBody: obstacleBody)
                if obstacleBody.colour == powerupColour {
                    explode(powerupObstacle: obstacleBody)
                }
            } else if let cannonballBody = physicsBody as? CannonballBody {
                explodeCannonball(cannonballBody)
            }
        }
    }

    private func explodeCannonball(_ cannonball: CannonballBody) {
        let currBodyVelocity = cannonball.velocity
        let kaboomVelocity = currBodyVelocity.tryToGetUnitVector()
            .scalarMultiply(with: kaboomVelocityMagnitude)
        cannonball.updateVelocity(kaboomVelocity)
    }
}
