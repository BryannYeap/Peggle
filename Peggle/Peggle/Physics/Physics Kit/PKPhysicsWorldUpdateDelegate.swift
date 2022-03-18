protocol PKPhysicsWorldUpdateDelegate: AnyObject {
    func didDestroyOutOfBoundBody(outOfBoundBody: PKPhysicsBody)
    func collisionDidOccur(physicsBody: PKPhysicsBody, newVelocity: Vector)
    func collisionDidOccur(physicsBodies: PKPhysicsBody...)
}
