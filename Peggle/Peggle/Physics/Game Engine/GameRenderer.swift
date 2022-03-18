class GameRenderer {

    private(set) var gameObjectToPhysicsBodiesMap: [GameObject: PKPhysicsBody] = [:]

    func map(gameObject: GameObject, toPhysicsBody physicsBody: PKPhysicsBody?) {
        guard physicsBody != nil else {
            gameObjectToPhysicsBodiesMap.removeValue(forKey: gameObject)
            return
        }
        gameObjectToPhysicsBodiesMap[gameObject] = physicsBody
    }

    func render(lag: Double) {
        for gameObject in gameObjectToPhysicsBodiesMap.keys {
            let correspondingPhysicsBody = gameObjectToPhysicsBodiesMap[gameObject]
            if let physicsBody = correspondingPhysicsBody {
                if let obstacleBody = physicsBody as? ObstacleBody {
                    renderObstacles(obstacleBody: obstacleBody, gameObject: gameObject)
                }
                if physicsBody.isDestroyed {
                    map(gameObject: gameObject, toPhysicsBody: nil)
                } else {
                    let displacement = physicsBody.velocity.scalarMultiply(with: lag)
                    let newPosition = physicsBody.position.add(vector: displacement)
                    gameObject.moveObject(to: newPosition)
                }
            }
        }
    }

    private func renderObstacles(obstacleBody: ObstacleBody, gameObject: GameObject) {
        guard let obstacle = gameObject as? Obstacle else {
            return
        }
        if obstacleBody.willBeDestroyed {
            obstacle.setWillBeDestroyedStatus(as: true)
        }
    }
}
