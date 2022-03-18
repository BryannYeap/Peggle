import Foundation

struct Vector: Codable {

    static private(set) var zero = Vector(xChange: 0.0, yChange: 0.0)

    private(set) var xChange: Double
    private(set) var yChange: Double

    init(xChange: Double, yChange: Double) {
        self.xChange = xChange
        self.yChange = yChange
    }

    func magnitute() -> Double {
        sqrt(self.xChange * self.xChange + self.yChange * self.yChange)
    }

    private func getUnitVector() throws -> Vector {
        let magnitude = self.magnitute()
        guard magnitude != 0 else {
            throw GeometryError.unattainableUnitVector("Attempted to calcualte unit vector of a zero vector")
        }
        return Vector(xChange: self.xChange / magnitude, yChange: self.yChange / magnitude)
    }

    func tryToGetUnitVector() -> Vector {
        do {
            return try self.getUnitVector()
        } catch GeometryError.unattainableUnitVector(let unattainableUnitVectorErrorMessage) {
            assert(false, unattainableUnitVectorErrorMessage)
        } catch {
            assert(false, "Unexpected error thrown while attempting to calcualte unit vector")
        }
    }

    func add(to vector: Vector) -> Vector {
        Vector(xChange: self.xChange + vector.xChange, yChange: self.yChange + vector.yChange)
    }

    func subtract(_ vector: Vector) -> Vector {
        Vector(xChange: self.xChange - vector.xChange, yChange: self.yChange - vector.yChange)
    }

    func scalarMultiply(with scalar: Double) -> Vector {
        Vector(xChange: self.xChange * scalar, yChange: self.yChange * scalar)
    }

    func dotProduct(with vector: Vector) -> Double {
        self.xChange * vector.xChange + self.yChange * vector.yChange
    }

    func crossProduct(with vector: Vector) -> Double {
        self.xChange * vector.yChange - vector.xChange * self.yChange
    }

    func getAngleInRadians(with vector: Vector) -> Double {
        let crossProduct = self.crossProduct(with: vector)
        let dotProduct = self.dotProduct(with: vector)
        return atan2(crossProduct, dotProduct)
    }

    func getAngleInDegrees(with vector: Vector) -> Double {
        getAngleInRadians(with: vector) * (180 / Double.pi)
    }
}
