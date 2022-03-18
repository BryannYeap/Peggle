class PKTriangleBody: PKPhysicsBody {

    private(set) var oscillatableBody: PKOscillatableBody?
    private(set) var colour: Colour?
    private(set) var isDynamic: Bool
    private(set) var mass: Double
    private(set) var restitution: Double
    internal var velocity: Vector
    internal var position: Point
    internal var edges: [Line]
    internal var isDestroyed: Bool
    internal var hasCollided: Bool
    private var minX: Double
    private var maxX: Double
    private var minY: Double
    private var maxY: Double

    init(isOscillatableAndSpringConstant: (Bool, Double?),
         colour: Colour? = nil,
         isDynamic: Bool = true,
         mass: Double = Double.greatestFiniteMagnitude,
         restitution: Double = 1.0,
         velocity: Vector = .zero,
         position: Point = .zero,
         firstEdge: Line = .zero,
         secondEdge: Line = .zero,
         thirdEdge: Line = .zero) {
        guard mass >= 0 else {
            assert(false, "Mass cannot be negative")
        }

        guard firstEdge.secondPoint == secondEdge.firstPoint &&
                secondEdge.secondPoint == thirdEdge.firstPoint &&
                thirdEdge.secondPoint == firstEdge.firstPoint else {
                    assert(false, "Triangle's edges must be connected")
                }

        self.colour = colour
        self.isDynamic = isDynamic
        self.mass = mass
        self.restitution = restitution
        self.velocity = velocity
        self.position = position
        self.edges = [firstEdge, secondEdge, thirdEdge]
        self.isDestroyed = false
        self.hasCollided = false
        self.minX = min(firstEdge.firstPoint.xCoord, secondEdge.firstPoint.xCoord, thirdEdge.firstPoint.xCoord)
        self.maxX = max(firstEdge.firstPoint.xCoord, secondEdge.firstPoint.xCoord, thirdEdge.firstPoint.xCoord)
        self.minY = min(firstEdge.firstPoint.yCoord, secondEdge.firstPoint.yCoord, thirdEdge.firstPoint.yCoord)
        self.maxY = max(firstEdge.firstPoint.yCoord, secondEdge.firstPoint.yCoord, thirdEdge.firstPoint.yCoord)

        let isOscillatable = isOscillatableAndSpringConstant.0
        if isOscillatable, let springConstant = isOscillatableAndSpringConstant.1 {
            self.oscillatableBody = PKOscillatableBody(pkPhysicsBody: self, springConstant: springConstant)
        }
    }

    var firstEdge: Line {
        edges[0]
    }

    var secondEdge: Line {
        edges[1]
    }

    var thirdEdge: Line {
        edges[2]
    }

    var firstPoint: Point {
        firstEdge.firstPoint
    }

    var secondPoint: Point {
        secondEdge.firstPoint
    }

    var thirdPoint: Point {
        thirdEdge.firstPoint
    }

    func updatePosition(_ newPosition: Point) {
        let displacement = newPosition.subtract(self.position)
        let newFirstPoint = self.firstPoint.add(vector: displacement)
        let newSecondPoint = self.secondPoint.add(vector: displacement)
        let newThirdPoint = self.thirdPoint.add(vector: displacement)
        edges[0] = Line(firstPoint: newFirstPoint, secondPoint: newSecondPoint)
        edges[1] = Line(firstPoint: newSecondPoint, secondPoint: newThirdPoint)
        edges[2] = Line(firstPoint: newThirdPoint, secondPoint: newFirstPoint)
        self.position = newPosition
    }

    func isIntersecting(with physicsBody: PKPhysicsBody) -> Bool {
        if let pkCircleBody = physicsBody as? PKCircleBody {
            return edgesAreIntersectingWithCircle(circle: pkCircleBody) || circleIsInsideTriangle(circle: pkCircleBody)
        }
        return false
    }

    func isIntersectingOnXAxis(xCoord: Double) -> Bool {
        xCoord >= minX && xCoord <= maxX
    }

    func isIntersectingOnYAxis(yCoord: Double) -> Bool {
        yCoord >= minY && yCoord <= maxY
    }

    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool {
        self.maxX <= minY || self.minX >= maxX || self.maxY <= minY || self.minY >= maxY
    }

    private func edgesAreIntersectingWithCircle(circle: PKCircleBody) -> Bool {
        let squaredRadius = circle.radius * circle.radius

        for edge in edges {
            if circle.position.squaredDistance(to: edge.firstPoint) < squaredRadius {
                return true
            }
            if circle.isIntersecting(with: edge) {
                return true
            }
        }

        return false
    }

    private func circleIsInsideTriangle(circle: PKCircleBody) -> Bool {
        // Check if point in polygon formula adapted from:
        // http://www.jeffreythompson.org/collision-detection/tri-point.php
        pointIsInsideTriangle(point: circle.position)
            && min(firstEdge.squaredLength, secondEdge.squaredLength, thirdEdge.squaredLength)
            > circle.radius * circle.radius
    }

    private func pointIsInsideTriangle(point: Point) -> Bool {
        // Check if point in polygon formula adapted from:
        // http://www.jeffreythompson.org/collision-detection/tri-point.php
        let area0rig = abs((secondPoint.xCoord - firstPoint.xCoord) * (thirdPoint.yCoord - firstPoint.yCoord)
                           - (thirdPoint.xCoord - firstPoint.xCoord) * (secondPoint.yCoord - firstPoint.yCoord))
        let area1 = abs((firstPoint.xCoord - point.xCoord) * (secondPoint.yCoord - point.yCoord)
                        - (secondPoint.xCoord - point.xCoord) * (firstPoint.yCoord - point.yCoord))
        let area2 = abs((secondPoint.xCoord - point.xCoord) * (thirdPoint.yCoord - point.yCoord)
                        - (thirdPoint.xCoord - point.xCoord) * (secondPoint.yCoord - point.yCoord))
        let area3 = abs((thirdPoint.xCoord - point.xCoord) * (firstPoint.yCoord - point.yCoord)
                        - (firstPoint.xCoord - point.xCoord) * (thirdPoint.yCoord - point.yCoord))
        return area1 + area2 + area3 == area0rig
    }
}
