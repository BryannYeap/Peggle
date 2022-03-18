import Foundation

class PKPhysicsWorld {

    var physicsBodies: [PKPhysicsBody]
    weak var pkPhysicsWorldUpdateDelegate: PKPhysicsWorldUpdateDelegate?

    let gravity: Vector
    let worldBounds: Rect

    init(physicsBodies: [PKPhysicsBody],
         gravity: Vector = Vector(xChange: 0.0, yChange: 680.0),
         worldBounds: Rect = .zero) {
        self.physicsBodies = physicsBodies
        self.gravity = gravity
        self.worldBounds = worldBounds
    }

    func setUpdateDelegate(as updateDelegate: PKPhysicsWorldUpdateDelegate) {
        self.pkPhysicsWorldUpdateDelegate = updateDelegate
    }

    func addPhysicsBody(_ physicsBody: PKPhysicsBody) {
        physicsBodies.append(physicsBody)
    }

    var countOfPhysicsBodies: Int {
        physicsBodies.count
    }

    func simulatePhysics(_ timeInterval: Double) {
        updatePhysicsBodies(timeInterval)
        resolveBodyCollisions(with: getPhysicsBodyAndCollisionVelocityPairs())
        resolveEdgeCollisions()
        destroyOutOfBoundBodies()
        removeAllPhysicsBodies(where: { $0.isDestroyed })
    }

    private func updatePhysicsBodies(_ timeInterval: Double) {
        for physicsBody in physicsBodies {
            let newVelocity = physicsBody.getNewVelocity(withGravity: gravity, during: timeInterval)
            let newPosition = physicsBody.getNewPosition(withNewVelocity: newVelocity, during: timeInterval)
            physicsBody.updateVelocity(newVelocity)
            physicsBody.updatePosition(newPosition)
        }
    }

    private func getPhysicsBodyAndCollisionVelocityPairs() -> [(PKPhysicsBody, Vector)] {
        var physicsBodyCollisionVelocityPairs: [(PKPhysicsBody, Vector)] = []
        for indexOfFirstBody in 0 ..< physicsBodies.count {
            let firstBody = physicsBodies[indexOfFirstBody]
            for indexOfSecondBody in indexOfFirstBody + 1 ..< physicsBodies.count {
                let secondBody = physicsBodies[indexOfSecondBody]

                guard firstBody.isDynamic || secondBody.isDynamic else {
                    continue
                }

                if firstBody.isIntersecting(with: secondBody) {
                    pkPhysicsWorldUpdateDelegate?.collisionDidOccur(physicsBodies: firstBody, secondBody)
                    let newCollisionVelocityPairs = getCollisionVelocities(between: firstBody, and: secondBody)
                    physicsBodyCollisionVelocityPairs.append(contentsOf: newCollisionVelocityPairs)
                }
            }
        }
        return physicsBodyCollisionVelocityPairs
    }

    private func getCollisionVelocities(between firstPhysicsBody: PKPhysicsBody,
                                        and secondPhysicsBody: PKPhysicsBody) -> [(PKPhysicsBody, Vector)] {
        var collisionVelocityPairs: [(PKPhysicsBody, Vector)] = []
        let normalisedCollisionVector = getNormalisedCollisionVector(firstPhysicsBody: firstPhysicsBody,
                                                                     secondPhysicsBody: secondPhysicsBody)
        let impulse = getImpulse(firstPhysicsBody: firstPhysicsBody,
                                 secondPhysicsBody: secondPhysicsBody,
                                 collisionVector: normalisedCollisionVector)
        if impulse > 0 {
            let collisionVelocity = normalisedCollisionVector.scalarMultiply(with: impulse)
            let (firstPhysicsBodyVelocity,
                 secondPhysicsBodyVelocity) = applyMomentum(firstPhysicsBody: firstPhysicsBody,
                                                            secondPhysicsBody: secondPhysicsBody,
                                                            collisionVelocity: collisionVelocity)
            collisionVelocityPairs.append((firstPhysicsBody, firstPhysicsBodyVelocity))
            collisionVelocityPairs.append((secondPhysicsBody, secondPhysicsBodyVelocity))
        }
        return collisionVelocityPairs
    }

    private func getNormalisedCollisionVector(firstPhysicsBody: PKPhysicsBody,
                                              secondPhysicsBody: PKPhysicsBody) -> Vector {
        let collisionVector = secondPhysicsBody.position.subtract(firstPhysicsBody.position)
        let normalisedCollisionVector = collisionVector.tryToGetUnitVector()
        return normalisedCollisionVector
    }

    private func getImpulse(firstPhysicsBody: PKPhysicsBody,
                            secondPhysicsBody: PKPhysicsBody,
                            collisionVector: Vector) -> Double {
        let numberOfBodies = 2.0
        let relativeVelocity = firstPhysicsBody.velocity.subtract(secondPhysicsBody.velocity)
        let resultantSpeed = relativeVelocity.dotProduct(with: collisionVector)
        let impulse = numberOfBodies * resultantSpeed / (firstPhysicsBody.mass + secondPhysicsBody.mass)
        let impulseAfterLossOfEnergy = impulse * min(firstPhysicsBody.restitution, secondPhysicsBody.restitution)
        return impulseAfterLossOfEnergy
    }

    private func applyMomentum(firstPhysicsBody: PKPhysicsBody,
                               secondPhysicsBody: PKPhysicsBody,
                               collisionVelocity: Vector) -> (Vector, Vector) {
        let firstPhysicsBodyMomentum = collisionVelocity.scalarMultiply(with: secondPhysicsBody.mass)
        let secondPhysicsBodyMomentum = collisionVelocity.scalarMultiply(with: firstPhysicsBody.mass)
        let firstPhysicsBodyVelocity = firstPhysicsBody.velocity.subtract(firstPhysicsBodyMomentum)
        let secondPhysicsBodyVelocity = secondPhysicsBody.velocity.add(to: secondPhysicsBodyMomentum)
        return (firstPhysicsBodyVelocity, secondPhysicsBodyVelocity)
    }

    private func resolveBodyCollisions(with physicsBodyNewVelocityPairs: [(PKPhysicsBody, Vector)]) {

        for (physicsBody, newVelocity) in physicsBodyNewVelocityPairs {
            pkPhysicsWorldUpdateDelegate?.collisionDidOccur(physicsBody: physicsBody, newVelocity: newVelocity)
            if physicsBody.canMove() {
                physicsBody.updateVelocity(newVelocity)
            }
        }
    }

    private func resolveEdgeCollisions() {
        for physicsBody in physicsBodies {
            resolveHorizontalEdgeCollisions(for: physicsBody)
            resolveTopEdgeCollision(for: physicsBody)
        }
    }

    private func resolveHorizontalEdgeCollisions(for physicsBody: PKPhysicsBody) {
        var newChangeInX: Double?

        if physicsBody.isIntersectingOnXAxis(xCoord: worldBounds.minX) {
            newChangeInX = abs(physicsBody.velocity.xChange) * physicsBody.restitution
        } else if physicsBody.isIntersectingOnXAxis(xCoord: worldBounds.maxX) {
            newChangeInX = -abs(physicsBody.velocity.xChange) * physicsBody.restitution
        }

        if let newChangeInX = newChangeInX {
            let newVelocity = Vector(xChange: newChangeInX, yChange: physicsBody.velocity.yChange)
            physicsBody.updateVelocity(newVelocity)
        }
    }

    private func resolveTopEdgeCollision(for physicsBody: PKPhysicsBody) {
        if physicsBody.isIntersectingOnYAxis(yCoord: worldBounds.minY) {
            let newChangeInY = abs(physicsBody.velocity.yChange) * physicsBody.restitution
            let newVelocity = Vector(xChange: physicsBody.velocity.xChange, yChange: newChangeInY)
            physicsBody.updateVelocity(newVelocity)
        }
    }

    private func destroyOutOfBoundBodies() {
        for physicsBody in physicsBodies {
            if physicsBody.isOutOfBounds(minX: worldBounds.minX,
                                         maxX: worldBounds.maxX,
                                         minY: worldBounds.minY,
                                         maxY: worldBounds.maxY) {
                physicsBody.destroyThisBody()
                pkPhysicsWorldUpdateDelegate?.didDestroyOutOfBoundBody(outOfBoundBody: physicsBody)
            }
        }
    }

    func removeAllPhysicsBodies(where shouldBeRemoved: (PKPhysicsBody) -> Bool) {
        physicsBodies.removeAll(where: shouldBeRemoved)
    }
}
