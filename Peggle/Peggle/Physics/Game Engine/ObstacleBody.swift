protocol ObstacleBody: PKPhysicsBody {
    var collisionLimit: Int { get }
    var collisionCounter: Int { get set }
    var willBeDestroyed: Bool { get }
    var isBlock: Bool { get }
    func setWillBeDestroyedStatus(as willBeDestroyed: Bool)
}

extension ObstacleBody {

    var isBlockingCannonball: Bool {
        collisionCounter > collisionLimit
    }

    func incrementCollisionCounter() {
        collisionCounter += 1
    }

    func resetCollisionCounter() {
        collisionCounter = 0
    }
}
