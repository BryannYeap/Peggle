struct Point: Codable, Equatable {

    static private(set) var zero = Point(xCoord: 0.0, yCoord: 0.0)

    var xCoord: Double
    var yCoord: Double

    init(xCoord: Double, yCoord: Double) {
        self.xCoord = xCoord
        self.yCoord = yCoord
    }

    func add(vector: Vector) -> Point {
        Point(xCoord: self.xCoord + vector.xChange, yCoord: self.yCoord + vector.yChange)
    }

    func subtract(_ point: Point) -> Vector {
        Vector(xChange: self.xCoord - point.xCoord, yChange: self.yCoord - point.yCoord)
    }

    func squaredDistance(to point: Point) -> Double {
        let horizontalDistance = self.xCoord - point.xCoord
        let verticalDistance = self.yCoord - point.yCoord
        return horizontalDistance * horizontalDistance + verticalDistance * verticalDistance
    }
}
