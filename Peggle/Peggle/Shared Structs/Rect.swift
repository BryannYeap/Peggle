struct Rect: Codable {

    static var zero: Rect {
        do {
            return try Rect(minX: 0.0, maxX: 0.0, minY: 0.0, maxY: 0.0)
        } catch {
            assert(false, "Zero rectangle could not be created")
        }
    }

    private(set) var minX: Double
    private(set) var maxX: Double
    private(set) var minY: Double
    private(set) var maxY: Double

    init(minX: Double, maxX: Double, minY: Double, maxY: Double) throws {
        guard maxX >= minX && maxY >= minX else {
            throw GeometryError
                .invalidBoundsError("Attempted to make a rectangle with a max bound smaller than a min bound")
        }
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }

    var midX: Double {
        (maxX + minX) / 2
    }

    var midY: Double {
        (maxY + minY) / 2
    }
}
