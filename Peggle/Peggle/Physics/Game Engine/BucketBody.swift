import Foundation

class BucketBody: PKRectBody {

    private let bucketEdgeBuffer = 0.1
    private let bucketDifferenceRatio = 0.125

    var leftEdge: Line {
        Line(firstPoint: Point(xCoord: minX,
                               yCoord: minY + (bucketDifferenceRatio * height)),
             secondPoint: Point(xCoord: minX,
                                yCoord: maxY))
    }

    var rightEdge: Line {
        Line(firstPoint: Point(xCoord: maxX,
                               yCoord: minY + (bucketDifferenceRatio * height)),
             secondPoint: Point(xCoord: maxX,
                                yCoord: maxY))
    }

    override func isIntersecting(with physicsBody: PKPhysicsBody) -> Bool {
        if let pkCircleBody = physicsBody as? PKCircleBody {
            let squaredRadius = pkCircleBody.radius * pkCircleBody.radius

            guard leftEdge.firstPoint.squaredDistance(to: pkCircleBody.position) > squaredRadius &&
                    leftEdge.secondPoint.squaredDistance(to: pkCircleBody.position) > squaredRadius &&
                    rightEdge.firstPoint.squaredDistance(to: pkCircleBody.position) > squaredRadius &&
                    rightEdge.secondPoint.squaredDistance(to: pkCircleBody.position) > squaredRadius else {
                        return true
                    }

            return pkCircleBody.isIntersecting(with: leftEdge) ||
                pkCircleBody.isIntersecting(with: rightEdge)
        }
        return false
    }

    func containsBody(physicsBody: PKPhysicsBody) -> Bool {
        if let pkCircleBody = physicsBody as? PKCircleBody {
            guard pkCircleBody.diameter <= width && pkCircleBody.diameter <= height else {
                return false
            }

            let xCoordWithinXAxisOfBucket = pkCircleBody.position.xCoord >= minX + pkCircleBody.radius &&
                pkCircleBody.position.xCoord <= maxX - pkCircleBody.radius
            let yCoordWithinYAxisOfBucket = pkCircleBody.position.yCoord >= minY + pkCircleBody.radius &&
                pkCircleBody.position.yCoord <= maxY - pkCircleBody.radius
            return xCoordWithinXAxisOfBucket && yCoordWithinYAxisOfBucket
        }
        return false
    }
}
