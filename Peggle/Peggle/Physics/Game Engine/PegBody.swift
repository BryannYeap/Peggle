class PegBody: PKCircleBody, ObstacleBody {

    private(set) var collisionLimit = 50
    private(set) var isBlock = false
    internal var collisionCounter = 0
    var willBeDestroyed = false

    init(isOscillatableAndSpringConstant: (Bool, Double?),
         colour: Colour,
         isDynamic: Bool = true,
         mass: Double = Double.greatestFiniteMagnitude,
         restitution: Double = 1.0,
         velocity: Vector = .zero,
         position: Point = .zero,
         radius: Double = 1.0) {
        super.init(isOscillatableAndSpringConstant: isOscillatableAndSpringConstant,
                   colour: colour,
                   isDynamic: isDynamic,
                   mass: mass,
                   restitution: restitution,
                   velocity: velocity,
                   position: position,
                   radius: radius)
    }

    func setWillBeDestroyedStatus(as willBeDestroyed: Bool) {
        self.willBeDestroyed = willBeDestroyed
    }
}
