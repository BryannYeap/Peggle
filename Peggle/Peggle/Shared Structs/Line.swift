import Foundation

struct Line: Codable {

    static private(set) var zero = Line(firstPoint: Point(xCoord: 0.0, yCoord: 0.0),
                                        secondPoint: Point(xCoord: 0.0, yCoord: 0.0))

    private(set) var firstPoint: Point
    private(set) var secondPoint: Point

    init(firstPoint: Point, secondPoint: Point) {
        self.firstPoint = firstPoint
        self.secondPoint = secondPoint
    }

    var squaredLength: Double {
        firstPoint.squaredDistance(to: secondPoint)
    }

    func minimumDistanceFromPointSquared(_ point: Point) -> Double {
        let firstVector = firstPoint.subtract(point)
        let secondVector = secondPoint.subtract(point)
        let crossProduct = firstVector.crossProduct(with: secondVector)
        let minimumDistanceFromCircleToLineSquared = (crossProduct * crossProduct) / squaredLength
        return minimumDistanceFromCircleToLineSquared
    }

    func projectionOfPointOntoLineIsOnLine(_ point: Point) -> Bool {
        firstPoint.subtract(point).dotProduct(with: firstPoint.subtract(secondPoint)) > 0 &&
        secondPoint.subtract(point).dotProduct(with: secondPoint.subtract(firstPoint)) > 0
    }

    func pointsLieOnSameSide(_ firstPoint: Point, _ secondPoint: Point) -> Bool {
        let firstCrossProduct = self.secondPoint.subtract(self.firstPoint)
            .crossProduct(with: firstPoint.subtract(self.firstPoint))
        let secondCrossProduct = self.secondPoint.subtract(self.firstPoint)
            .crossProduct(with: secondPoint.subtract(self.firstPoint))
        return firstCrossProduct * secondCrossProduct >= 0
    }
}
