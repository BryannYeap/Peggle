class TriangleBody: PKTriangleBody, ObstacleBody {

    private(set) var collisionLimit = 60
    private(set) var isBlock: Bool
    internal var collisionCounter = 0
    var willBeDestroyed = false

    init(isOscillatableAndSpringConstant: (Bool, Double?),
         colour: Colour,
         isBlock: Bool,
         isDynamic: Bool = true,
         mass: Double = Double.greatestFiniteMagnitude,
         restitution: Double = 1.0,
         velocity: Vector = .zero,
         position: Point = .zero,
         firstEdge: Line = .zero,
         secondEdge: Line = .zero,
         thirdEdge: Line = .zero) {
        self.isBlock = isBlock
        super.init(isOscillatableAndSpringConstant: isOscillatableAndSpringConstant,
                   colour: colour,
                   isDynamic: isDynamic,
                   mass: mass,
                   restitution: restitution,
                   velocity: velocity,
                   position: position,
                   firstEdge: firstEdge,
                   secondEdge: secondEdge,
                   thirdEdge: thirdEdge)
    }

    func setWillBeDestroyedStatus(as willBeDestroyed: Bool) {
        guard !isBlock else {
            return
        }
        self.willBeDestroyed = willBeDestroyed
    }
}
