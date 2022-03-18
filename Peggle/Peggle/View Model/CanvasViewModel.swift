import Foundation

class CanvasViewModel: ObservableObject {
    // TO BE OVERRIDEN
    var levelGameObjects: [GameObject] { [] }
    var cannonballs: [Cannonball] { [] }
    func backgroundOnDragGesture(_ coord: Point) {}
    func backgroundOnTapGesture(at coord: Point) {}
    func obstacleOnTapGesture(_ obstacle: Obstacle?) {}
    func obstacleOnLongPressGesture(_ obstacle: Obstacle?) {}
    func obstacleOnDragGesture(obstacle: Obstacle?, coord: Point) {}
}
