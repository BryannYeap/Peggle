import Darwin

class PegObstacle: GameObject, CircleGameObject {

    private let defaultSpringConstant = 0.0
    private let defaultRadius = 25.0
    private let defaultIsBlock = false

    private(set) var oscillatingSpringConstant: Double
    private(set) var willBeDestroyed = false
    private(set) var isBlock: Bool
    var radius: Double

    private enum CodingKeys: String, CodingKey {
        case oscillatingSpringConstant
        case isBlock
        case radius
    }

    override init(coordinate: Point) {
        self.oscillatingSpringConstant = defaultSpringConstant
        self.isBlock = defaultIsBlock
        self.radius = defaultRadius
        super.init(coordinate: coordinate)
    }

    convenience init(isBlock: Bool, radius: Double, coordinate: Point) {
        self.init(coordinate: coordinate)
        self.isBlock = isBlock
        self.radius = radius
    }

    convenience init(isBlock: Bool, coordinate: Point) {
        self.init(coordinate: coordinate)
        self.isBlock = isBlock
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.oscillatingSpringConstant = try container.decode(Double.self, forKey: CodingKeys.oscillatingSpringConstant)
        self.isBlock = try container.decode(Bool.self, forKey: CodingKeys.isBlock)
        self.radius = try container.decode(Double.self, forKey: CodingKeys.radius)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oscillatingSpringConstant, forKey: CodingKeys.oscillatingSpringConstant)
        try container.encode(isBlock, forKey: CodingKeys.isBlock)
        try container.encode(radius, forKey: CodingKeys.radius)
        try super.encode(to: encoder)
    }

    func movePeg(to coord: Point) {
        moveObject(to: coord)
    }

    func updateSpringConstant(to springConstant: Double) {
        self.oscillatingSpringConstant = springConstant
    }
}

extension PegObstacle: Obstacle {

    func setWillBeDestroyedStatus(as willBeDestroyed: Bool) {
        guard !isBlock else {
            return
        }
        self.willBeDestroyed = willBeDestroyed
    }

    func isIntersecting(with obstacle: Obstacle) -> Bool {
        if let pegObstacle = obstacle as? PegObstacle {
            let distanceBetweenCirclesSquared = coordinate.squaredDistance(to: pegObstacle.coordinate)
            let sumOfRadiusSquared = (radius + pegObstacle.radius) * (radius + pegObstacle.radius)
            return distanceBetweenCirclesSquared <= sumOfRadiusSquared
        } else if let triangleObstacle = obstacle as? TriangleObstacle {
            return triangleObstacle.isIntersecting(with: self)
        } else {
            return false
        }
    }

    func isFullyToTheRight(of xCoord: Double) -> Bool {
        self.coordinate.xCoord > xCoord + self.radius
    }

    func isFullyToTheLeft(of xCoord: Double) -> Bool {
        self.coordinate.xCoord < xCoord - self.radius
    }

    func isFullyBelow(of yCoord: Double) -> Bool {
        self.coordinate.yCoord > yCoord + self.radius
    }

    func isFullyAbove(of yCoord: Double) -> Bool {
        self.coordinate.yCoord < yCoord - self.radius
    }

    func resize(towards coord: Point) {
        let squaredDistanceToCoord = coordinate.squaredDistance(to: coord)

        guard squaredDistanceToCoord <= 4 * defaultRadius * defaultRadius &&
           squaredDistanceToCoord >= defaultRadius * defaultRadius else {
            return
        }

        radius = sqrt(squaredDistanceToCoord)
    }

    func obtainState(from obstacle: Obstacle) {
        guard let pegObstacle = obstacle as? PegObstacle else {
            return
        }

        movePeg(to: pegObstacle.coordinate)
        self.radius = pegObstacle.radius
    }

    func getDeepCopy() -> Obstacle {
        PegObstacle(isBlock: false,
                    radius: self.radius,
                    coordinate: self.coordinate)
    }

}
