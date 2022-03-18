import Foundation

class PKCircleBody: PKPhysicsBody {

    private(set) var oscillatableBody: PKOscillatableBody?
    private(set) var colour: Colour?
    private(set) var isDynamic: Bool
    private(set) var mass: Double
    private(set) var restitution: Double
    internal var velocity: Vector
    internal var position: Point
    internal var radius: Double
    internal var diameter: Double
    internal var isDestroyed: Bool
    internal var hasCollided: Bool

    init(isOscillatableAndSpringConstant: (Bool, Double?),
         colour: Colour? = nil,
         isDynamic: Bool = true,
         mass: Double = Double.greatestFiniteMagnitude,
         restitution: Double = 1.0,
         velocity: Vector = .zero,
         position: Point = .zero,
         radius: Double = 1.0) {
        guard radius >= 0 && mass >= 0 else {
            assert(false, "Radius and mass cannot be negative")
        }

        self.colour = colour
        self.isDynamic = isDynamic
        self.mass = mass
        self.restitution = restitution
        self.velocity = velocity
        self.position = position
        self.radius = radius
        self.diameter = 2 * radius
        self.isDestroyed = false
        self.hasCollided = false

        let isOscillatable = isOscillatableAndSpringConstant.0
        if isOscillatable, let springConstant = isOscillatableAndSpringConstant.1 {
            self.oscillatableBody = PKOscillatableBody(pkPhysicsBody: self, springConstant: springConstant)
        }
    }

    func updatePosition(_ newPosition: Point) {
        self.position = newPosition
    }

    func isIntersecting(with physicsBody: PKPhysicsBody) -> Bool {
        if let pkCircleBody = physicsBody as? PKCircleBody {
            let distanceBetweenCirclesSquared = position.squaredDistance(to: pkCircleBody.position)
            let sumOfRadiusSquared = (radius + pkCircleBody.radius) * (radius + pkCircleBody.radius)
            return distanceBetweenCirclesSquared < sumOfRadiusSquared
        } else if let pkRectBody = physicsBody as? PKRectBody {
            return pkRectBody.isIntersecting(with: self)
        } else if let pkTriangleBody = physicsBody as? PKTriangleBody {
            return pkTriangleBody.isIntersecting(with: self)
        } else {
            return false
        }
    }

    func isIntersectingOnXAxis(xCoord: Double) -> Bool {
        abs(self.position.xCoord - xCoord) < self.radius
    }

    func isIntersectingOnYAxis(yCoord: Double) -> Bool {
        abs(self.position.yCoord - yCoord) < self.radius
    }

    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool {
        isIntersectingOnXAxis(xCoord: minX - diameter) || isIntersectingOnXAxis(xCoord: maxX + diameter) ||
        isIntersectingOnYAxis(yCoord: minY - diameter) || isIntersectingOnYAxis(yCoord: maxY + diameter)
    }

    func isIntersecting(with line: Line) -> Bool {guard line.projectionOfPointOntoLineIsOnLine(self.position) else {
            return false
        }

        let squaredRadius = self.radius * self.radius
        let minimumDistanceFromCircleToLineSquared = line.minimumDistanceFromPointSquared(self.position)
        return minimumDistanceFromCircleToLineSquared <= squaredRadius
    }
}
