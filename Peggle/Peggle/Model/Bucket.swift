class Bucket: GameObject, RectGameObject {

    var width: Double = 150
    var height: Double = 150

    override init(coordinate: Point) {
        super.init(coordinate: coordinate)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
