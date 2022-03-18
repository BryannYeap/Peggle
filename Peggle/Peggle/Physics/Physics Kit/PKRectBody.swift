import Foundation

class PKRectBody: PKPhysicsBody {

    private(set) var oscillatableBody: PKOscillatableBody?
    private(set) var colour: Colour?
    private(set) var isDynamic: Bool
    private(set) var mass: Double
    private(set) var restitution: Double
    internal var velocity: Vector
    internal var position: Point
    internal var width: Double
    internal var height: Double
    internal var halfWidth: Double
    internal var halfHeight: Double
    internal var isDestroyed: Bool
    internal var hasCollided: Bool

    init(isOscillatableAndSpringConstant: (Bool, Double?),
         colour: Colour? = nil,
         isDynamic: Bool = true,
         mass: Double = Double.greatestFiniteMagnitude,
         restitution: Double = 1.0,
         velocity: Vector = .zero,
         position: Point = .zero,
         width: Double = 1.0,
         height: Double = 1.0) {
        guard width >= 0 && height >= 0 && mass >= 0 else {
            assert(false, "Width, height and mass cannot be negative")
        }

        self.colour = colour
        self.isDynamic = isDynamic
        self.mass = mass
        self.restitution = restitution
        self.velocity = velocity
        self.position = position
        self.width = width
        self.height = height
        self.halfWidth = width / 2
        self.halfHeight = height / 2
        self.isDestroyed = false
        self.hasCollided = false

        let isOscillatable = isOscillatableAndSpringConstant.0
        if isOscillatable, let springConstant = isOscillatableAndSpringConstant.1 {
            self.oscillatableBody = PKOscillatableBody(pkPhysicsBody: self, springConstant: springConstant)
        }
    }

    var minY: Double {
        position.yCoord - halfHeight
    }

    var maxY: Double {
        position.yCoord + halfHeight
    }

    var minX: Double {
        position.xCoord - halfWidth
    }

    var maxX: Double {
        position.xCoord + halfWidth
    }

    func updatePosition(_ newPosition: Point) {
        self.position = newPosition
    }

    func isIntersecting(with physicsBody: PKPhysicsBody) -> Bool {
        if let pkCircleBody = physicsBody as? PKCircleBody {
            let xCoordToCheck = getXCoordToCheck(againstCircle: pkCircleBody)
            let yCoordToCheck = getYCoordToCheck(againstCircle: pkCircleBody)
            let squaredDistance = Point(xCoord: xCoordToCheck, yCoord: yCoordToCheck)
                .squaredDistance(to: pkCircleBody.position)
            let squareRadius = pkCircleBody.radius * pkCircleBody.radius
            return squaredDistance < squareRadius
        }
        return false
    }

    internal func getXCoordToCheck(againstCircle pkCircleBody: PKCircleBody) -> Double {
        var xCoordToCheck = pkCircleBody.position.xCoord
        if pkCircleBody.position.xCoord <= minX {
            xCoordToCheck = minX
        } else if pkCircleBody.position.xCoord >= maxX {
            xCoordToCheck = maxX
        }
        return xCoordToCheck
    }

    internal func getYCoordToCheck(againstCircle pkCircleBody: PKCircleBody) -> Double {
        var yCoordToCheck = pkCircleBody.position.yCoord
        if pkCircleBody.position.yCoord <= minY {
            yCoordToCheck = minY
        } else if pkCircleBody.position.yCoord >= maxY {
            yCoordToCheck = maxY
        }
        return yCoordToCheck
    }

    func isIntersectingOnXAxis(xCoord: Double) -> Bool {
        abs(self.position.xCoord - xCoord) < (self.width / 2)
    }

    func isIntersectingOnYAxis(yCoord: Double) -> Bool {
        abs(self.position.yCoord - yCoord) < (self.height / 2)
    }

    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool {
        isIntersectingOnXAxis(xCoord: minX - width) || isIntersectingOnXAxis(xCoord: maxX + width) ||
        isIntersectingOnYAxis(yCoord: minY - height) || isIntersectingOnYAxis(yCoord: maxY + height)
    }
}
