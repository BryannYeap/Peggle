protocol CircleGameObject: GameObject {
    var radius: Double { get set }
}

extension CircleGameObject {
    var diameter: Double {
        2.0 * radius
    }
}
