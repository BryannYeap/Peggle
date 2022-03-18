class PKOscillatableBody {

    private weak var pkPhysicsBody: PKPhysicsBody?

    private let energyLoss: Double = 0.99
    private let springConstant: Double
    private let restPosition: Point
    private var anchorPosition: Point = .zero

    var isOscillating: Bool

    init(pkPhysicsBody: PKPhysicsBody, springConstant: Double) {
        self.pkPhysicsBody = pkPhysicsBody
        self.springConstant = springConstant
        self.isOscillating = false
        self.restPosition = pkPhysicsBody.position
    }

    func getNewVelocity(during timeInterval: Double) -> Vector {

        guard let pkPhysicsBody = pkPhysicsBody else {
            assert(false, "Cannot find asscociated PKPhysicsBody in PKOscillatableBody")
        }

        let force = pkPhysicsBody.position.subtract(self.anchorPosition)

        guard force.magnitute() != 0 else {
            stopOscillating()
            return .zero
        }

        let displacementFromRest = force.magnitute() - self.restPosition.subtract(self.anchorPosition).magnitute()
        let forceDirection = force.tryToGetUnitVector().scalarMultiply(with: -springConstant * displacementFromRest)
        let acceleration = forceDirection.scalarMultiply(with: 1 / pkPhysicsBody.mass)
        let newVelocity = pkPhysicsBody.velocity.add(to: acceleration.scalarMultiply(with: timeInterval))

        guard newVelocity.magnitute() > 0.05 else {
            stopOscillating()
            return .zero
        }

        return newVelocity.scalarMultiply(with: energyLoss)
    }

    func oscillate(withVelocity newVelocity: Vector) {
        isOscillating = true
        self.anchorPosition = self.restPosition.add(vector: newVelocity.scalarMultiply(with: -1.0))
    }

    private func stopOscillating() {
        isOscillating = false
        pkPhysicsBody?.updateVelocity(.zero)
        pkPhysicsBody?.updatePosition(restPosition)
    }
}
