import Foundation

protocol PKPhysicsBody: AnyObject {

    var oscillatableBody: PKOscillatableBody? { get }
    var colour: Colour? { get }
    var isDynamic: Bool { get }
    var mass: Double { get }
    var restitution: Double { get }
    var velocity: Vector { get set }
    var position: Point { get set }
    var isDestroyed: Bool { get set }
    var hasCollided: Bool { get set }

    func updatePosition(_ newPosition: Point)
    func isIntersecting(with physicsBody: PKPhysicsBody) -> Bool
    func isIntersectingOnXAxis(xCoord: Double) -> Bool
    func isIntersectingOnYAxis(yCoord: Double) -> Bool
    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool
}

extension PKPhysicsBody {

    var isOscillatable: Bool {
        oscillatableBody != nil
    }

    func canMove() -> Bool {
        oscillatableBody?.isOscillating ?? isDynamic
    }

    func getNewVelocity(withGravity gravity: Vector, during timeInterval: Double) -> Vector {
        if let oscillatableBody = oscillatableBody, oscillatableBody.isOscillating {
            return oscillatableBody.getNewVelocity(during: timeInterval)
        } else if self.isDynamic {
            return self.velocity.add(to: gravity.scalarMultiply(with: timeInterval))
        } else {
            return self.velocity
        }
    }

    func updateVelocity(_ newVelocity: Vector) {
        self.velocity = newVelocity
    }

    func destroyThisBody() {
        self.isDestroyed = true
    }

    func isWithin(distance: Double, of coord: Point) -> Bool {
        return position.squaredDistance(to: coord) <= distance * distance
    }

    func getNewPosition(withNewVelocity velocity: Vector, during timeInterval: Double) -> Point {
        let displacement = velocity.scalarMultiply(with: timeInterval)
        let newPosition = self.position.add(vector: displacement)
        return newPosition
    }

}
