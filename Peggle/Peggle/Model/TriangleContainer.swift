struct TriangleContainer: Codable {

    private var blueTriangles: [TriangleBlue]
    private var orangeTriangles: [TriangleOrange]
    private var greenTriangles: [TriangleGreen]
    private var redTriangles: [TriangleRed]

    init(blueTriangles: [TriangleBlue] = [],
         orangeTriangles: [TriangleOrange] = [],
         greenTriangles: [TriangleGreen] = [],
         redTriangles: [TriangleRed] = []) {
        self.blueTriangles = blueTriangles
        self.orangeTriangles = orangeTriangles
        self.greenTriangles = greenTriangles
        self.redTriangles = redTriangles
    }

    var numberOfOrangeTriangles: Int {
        orangeTriangles.count
    }

    mutating func addTriangle(_ triangle: TriangleObstacle) {
        if let blueTriangle = triangle as? TriangleBlue {
            blueTriangles.append(blueTriangle)
        } else if let orangeTriangle = triangle as? TriangleOrange {
            orangeTriangles.append(orangeTriangle)
        } else if let greenTriangle = triangle as? TriangleGreen {
            greenTriangles.append(greenTriangle)
        } else if let redTriangle = triangle as? TriangleRed {
            redTriangles.append(redTriangle)
        } else {
            assert(false, "Attempting to add a type of peg that cannot be determined in peg container")
        }
    }

    mutating func removeAllTriangles(where shouldBeRemoved: (TriangleObstacle) -> Bool ) {
        blueTriangles.removeAll(where: shouldBeRemoved)
        orangeTriangles.removeAll(where: shouldBeRemoved)
        greenTriangles.removeAll(where: shouldBeRemoved)
        redTriangles.removeAll(where: shouldBeRemoved)
    }

    mutating func movePeg(_ triangle: TriangleObstacle, to coord: Point) {
        triangle.moveTriangle(to: coord)
    }

    mutating func removeAllTriangles() {
        blueTriangles = []
        orangeTriangles = []
        greenTriangles = []
        redTriangles = []
    }

    func getTriangles() -> [TriangleObstacle] {
        var triangles: [TriangleObstacle] = []
        triangles.append(contentsOf: blueTriangles)
        triangles.append(contentsOf: orangeTriangles)
        triangles.append(contentsOf: greenTriangles)
        triangles.append(contentsOf: redTriangles)
        return triangles
    }

    func getDeepCopy() -> TriangleContainer {
        var blueTrianglesCopy: [TriangleBlue] = []
        var orangeTrianglesCopy: [TriangleOrange] = []
        var greenTrianglesCopy: [TriangleGreen] = []
        var redTrianglesCopy: [TriangleRed] = []

        for blueTriangle in blueTriangles {
            blueTrianglesCopy.append(blueTriangle.getDeepCopyTriangleBlue())
        }

        for orangeTriangle in orangeTriangles {
            orangeTrianglesCopy.append(orangeTriangle.getDeepCopyTriangleOrange())
        }

        for greenTriangle in greenTriangles {
            greenTrianglesCopy.append(greenTriangle.getDeepCopyTriangleGreen())
        }

        for redTriangle in redTriangles {
            redTrianglesCopy.append(redTriangle.getDeepCopyTriangleRed())
        }

        return TriangleContainer(blueTriangles: blueTrianglesCopy,
                                 orangeTriangles: orangeTrianglesCopy,
                                 greenTriangles: greenTrianglesCopy,
                                 redTriangles: redTrianglesCopy)
    }
}
