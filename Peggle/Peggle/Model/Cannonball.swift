class Cannonball: GameObject, CircleGameObject {

    var radius: Double = 18.75

    override init(coordinate: Point = .zero) {
        super.init(coordinate: coordinate)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
