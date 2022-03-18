import Foundation

class TriangleObstacle: GameObject, TriangleGameObject {

    private let defaultSpringConstant = 0.0
    private let defaultWidth = 50.0
    private let defaultHeight = 50.0
    private let defaultIsBlock = false

    private(set) var oscillatingSpringConstant: Double
    private(set) var willBeDestroyed = false
    private(set) var isBlock: Bool
    internal var width: Double
    internal var height: Double

    private enum CodingKeys: String, CodingKey {
        case oscillatingSpringConstant
        case isBlock
        case width
        case height
    }

    override init(coordinate: Point) {
        self.oscillatingSpringConstant = defaultSpringConstant
        self.width = defaultWidth
        self.height = defaultHeight
        self.isBlock = defaultIsBlock
        super.init(coordinate: coordinate)
    }

    convenience init(isBlock: Bool, width: Double, height: Double, coordinate: Point) {
        self.init(coordinate: coordinate)
        self.isBlock = isBlock
        self.width = width
        self.height = height
    }

    convenience init(isBlock: Bool, coordinate: Point) {
        self.init(coordinate: coordinate)
        self.isBlock = isBlock
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.oscillatingSpringConstant = try container.decode(Double.self, forKey: CodingKeys.oscillatingSpringConstant)
        self.isBlock = try container.decode(Bool.self, forKey: CodingKeys.isBlock)
        self.width = try container.decode(Double.self, forKey: CodingKeys.width)
        self.height = try container.decode(Double.self, forKey: CodingKeys.height)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oscillatingSpringConstant, forKey: CodingKeys.oscillatingSpringConstant)
        try container.encode(isBlock, forKey: CodingKeys.isBlock)
        try container.encode(width, forKey: CodingKeys.width)
        try container.encode(height, forKey: CodingKeys.height)
        try super.encode(to: encoder)
    }

    func moveTriangle(to coord: Point) {
        moveObject(to: coord)
    }

    func updateSpringConstant(to springConstant: Double) {
        self.oscillatingSpringConstant = springConstant
    }
}

extension TriangleObstacle: Obstacle {

    func setWillBeDestroyedStatus(as willBeDestroyed: Bool) {
        guard !isBlock else {
            return
        }
        self.willBeDestroyed = willBeDestroyed
    }

    func isIntersecting(with obstacle: Obstacle) -> Bool {
        if let peg = obstacle as? PegObstacle {
            return isIntersecting(with: peg) || pegIsInsideTriangle(peg: peg)
        } else if let triangle = obstacle as? TriangleObstacle {
            return !isNotIntersecting(with: triangle)
        } else {
            return false
        }
    }

    private func isIntersecting(with peg: PegObstacle) -> Bool {
        let squaredRadius = peg.radius * peg.radius

        for edge in edges {
            if peg.coordinate.squaredDistance(to: edge.firstPoint) < squaredRadius {
                return true
            }
            if edgeIsIntersectingWithPeg(edge: edge, peg: peg) {
                return true
            }
        }

        return false
    }

    private func edgeIsIntersectingWithPeg(edge: Line, peg: PegObstacle) -> Bool {
        guard edge.projectionOfPointOntoLineIsOnLine(peg.coordinate) else {
            return false
        }

        let squaredRadius = peg.radius * peg.radius
        let minimumDistanceFromPegToLineSquared = edge.minimumDistanceFromPointSquared(peg.coordinate)
        let edgeIsIntersectingPeg = minimumDistanceFromPegToLineSquared <= squaredRadius
        return edgeIsIntersectingPeg
    }

    private func pegIsInsideTriangle(peg: PegObstacle) -> Bool {
        pointIsInsideTriangle(point: peg.coordinate)
            && min(firstEdge.squaredLength, secondEdge.squaredLength, thirdEdge.squaredLength)
            > peg.radius * peg.radius
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

    private func isNotIntersecting(with triangle: TriangleObstacle) -> Bool {
        // Check if 2 triangles are not intersecting adapted from:
        // https://stackoverflow.com/questions/2778240/detection-of-triangle-collision-in-2d-space
        let selfPoints = [self.firstPoint, self.secondPoint, self.thirdPoint]
        let trianglePoints = [triangle.firstPoint, triangle.secondPoint, triangle.thirdPoint]
        for edge in self.edges {
            if let nonParticipatingPoint = selfPoints
                .first(where: { $0 != edge.firstPoint && $0 != edge.secondPoint }) {
                if (edge.pointsLieOnSameSide(triangle.firstPoint, triangle.secondPoint)
                     && edge.pointsLieOnSameSide(triangle.secondPoint, triangle.thirdPoint))
                    && !(edge.pointsLieOnSameSide(triangle.firstPoint, nonParticipatingPoint)) {
                    return true
                }
            }
        }
        for edge in triangle.edges {
            if let nonParticipatingPoint = trianglePoints
                .first(where: { $0 != edge.firstPoint && $0 != edge.secondPoint }) {
                if (edge.pointsLieOnSameSide(self.firstPoint, self.secondPoint)
                      && edge.pointsLieOnSameSide(self.secondPoint, self.thirdPoint))
                    && !(edge.pointsLieOnSameSide(self.firstPoint, nonParticipatingPoint)) {
                    return true
                }
            }
        }
        return false
    }

    func isFullyToTheRight(of xCoord: Double) -> Bool {
        minX > xCoord
    }

    func isFullyToTheLeft(of xCoord: Double) -> Bool {
        maxX < xCoord
    }

    func isFullyBelow(of yCoord: Double) -> Bool {
        minY > yCoord
    }

    func isFullyAbove(of yCoord: Double) -> Bool {
        maxY < yCoord
    }

    func resize(towards coord: Point) {
        let newWidth = abs(coordinate.xCoord - coord.xCoord) * 2
        let newHeight = abs(coordinate.yCoord - coord.yCoord) * 2

        if newWidth <= 2 * defaultWidth && newWidth >= defaultWidth {
            width = newWidth
        }

        if newHeight <= 2 * defaultHeight && newHeight >= defaultHeight {
            height = newHeight
        }
    }

    func obtainState(from obstacle: Obstacle) {
        guard let triangleObstacle = obstacle as? TriangleObstacle else {
            return
        }

        moveTriangle(to: triangleObstacle.coordinate)
        self.width = triangleObstacle.width
        self.height = triangleObstacle.height
    }

    func getDeepCopy() -> Obstacle {
        TriangleObstacle(isBlock: self.isBlock,
                         width: self.width,
                         height: self.height,
                         coordinate: self.coordinate)
    }
}
