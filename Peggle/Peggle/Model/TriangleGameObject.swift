protocol TriangleGameObject: Obstacle {
    var width: Double { get set }
    var height: Double { get set }
}

extension TriangleGameObject {

    var firstPoint: Point {
        Point(xCoord: coordinate.xCoord,
              yCoord: coordinate.yCoord - (height / 2))
    }

    var secondPoint: Point {
        Point(xCoord: coordinate.xCoord - (width / 2),
              yCoord: coordinate.yCoord + (height / 2))
    }

    var thirdPoint: Point {
        Point(xCoord: coordinate.xCoord + (width / 2),
              yCoord: coordinate.yCoord + (height / 2))
    }

    var firstEdge: Line {
        Line(firstPoint: firstPoint, secondPoint: secondPoint)
    }

    var secondEdge: Line {
        Line(firstPoint: secondPoint, secondPoint: thirdPoint)
    }

    var thirdEdge: Line {
        Line(firstPoint: thirdPoint, secondPoint: firstPoint)
    }

    var edges: [Line] {
        [firstEdge, secondEdge, thirdEdge]
    }

    var minX: Double {
        min(firstPoint.xCoord, secondPoint.xCoord, thirdPoint.xCoord)
    }

    var maxX: Double {
        max(firstPoint.xCoord, secondPoint.xCoord, thirdPoint.xCoord)
    }

    var minY: Double {
        min(firstPoint.yCoord, secondPoint.yCoord, thirdPoint.yCoord)
    }

    var maxY: Double {
        max(firstPoint.yCoord, secondPoint.yCoord, thirdPoint.yCoord)
    }
}
