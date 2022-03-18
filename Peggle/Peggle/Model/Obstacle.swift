protocol Obstacle: GameObject {
    var oscillatingSpringConstant: Double { get }
    var willBeDestroyed: Bool { get }
    var isBlock: Bool { get }
    func updateSpringConstant(to springConstant: Double)
    func setWillBeDestroyedStatus(as willBeDestroyed: Bool)
    func isIntersecting(with gameObject: Obstacle) -> Bool
    func isFullyToTheRight(of xCoord: Double) -> Bool
    func isFullyToTheLeft(of xCoord: Double) -> Bool
    func isFullyBelow(of yCoord: Double) -> Bool
    func isFullyAbove(of yCoord: Double) -> Bool
    func resize(towards coord: Point)
    func obtainState(from obstacle: Obstacle)
    func getDeepCopy() -> Obstacle
}

extension Obstacle {

    var minimumOscillatingSpringConstant: Double {
        5000.0
    }

    var maximumOscillatingSpringConstant: Double {
        100000.0
    }

    var nonOscillatableSpringConstant: Double {
        0.0
    }

    var isOscillatable: Bool {
        oscillatingSpringConstant != nonOscillatableSpringConstant
    }
}
