import Foundation

struct Level: Identifiable, Codable {

    let isPreloadedLevel: Bool
    private(set) var id: String
    private(set) var pegs: PegContainer
    private(set) var triangles: TriangleContainer

    init(nameOfLevel: String = "",
         pegs: PegContainer = .init(),
         triangles: TriangleContainer = .init(),
         isPreloadedLevel: Bool = false) {
        self.id = nameOfLevel
        self.pegs = pegs
        self.triangles = triangles
        self.isPreloadedLevel = isPreloadedLevel
    }

    mutating func addGameObject(_ gameObject: GameObject) {
        if let peg = gameObject as? PegObstacle {
            pegs.addPeg(peg)
        } else if let triangle = gameObject as? TriangleObstacle {
            triangles.addTriangle(triangle)
        } else {
            assert(false, "Attempting to add a Game Object from level that cannot be identified")
        }
    }

    mutating func removeGameObject(_ gameObject: GameObject) {
        if let peg = gameObject as? PegObstacle {
            pegs.removeAllPegs(where: { $0 == peg })
        } else if let triangle = gameObject as? TriangleObstacle {
            triangles.removeAllTriangles(where: { $0 == triangle })
        } else {
            assert(false, "Attempting to remove a Game Object from level that cannot be identified")
        }
    }

    mutating func moveGameObject(_ gameObject: GameObject, to coord: Point) {
        gameObject.moveObject(to: coord)
    }

    mutating func setName(as name: String) {
        id = name
    }

    mutating func removeAll() {
        pegs.removeAllPegs()
        triangles.removeAllTriangles()
    }

    mutating func resetObstacles() {
        for peg in pegs.getPegs() {
            peg.setWillBeDestroyedStatus(as: false)
        }

        for triangle in triangles.getTriangles() {
            triangle.setWillBeDestroyedStatus(as: false)
        }
    }

    func getGameObjects() -> [GameObject] {
        var gameObjects: [GameObject] = []
        gameObjects.append(contentsOf: getPegs())
        gameObjects.append(contentsOf: getTriangles())
        return gameObjects
    }

    private func getPegs() -> [PegObstacle] {
        pegs.getPegs()
    }

    private func getTriangles() -> [TriangleObstacle] {
        triangles.getTriangles()
    }

    func getNumberOfOrangeObstacles() -> Int {
        pegs.numberOfOrangePegs + triangles.numberOfOrangeTriangles
    }

    mutating func resizeObstacle(_ obstacle: Obstacle, towards coord: Point) {
        obstacle.resize(towards: coord)
    }

    mutating func changeSpringConstant(_ obstacle: Obstacle, towards coord: Point) {

        let squaredDistanceToCoord = obstacle.coordinate.squaredDistance(to: coord)

        guard squaredDistanceToCoord <= obstacle.maximumOscillatingSpringConstant else {
            return
        }

        guard squaredDistanceToCoord >= obstacle.minimumOscillatingSpringConstant else {
            obstacle.updateSpringConstant(to: obstacle.nonOscillatableSpringConstant)
            return
        }

        obstacle.updateSpringConstant(to: squaredDistanceToCoord)
    }

    func getDeepCopy() -> Level {
        Level(nameOfLevel: id,
              pegs: pegs.getDeepCopy(),
              triangles: triangles.getDeepCopy(),
              isPreloadedLevel: false)
    }
}
