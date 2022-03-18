import Foundation

class GameObject: Hashable, Identifiable, Codable {

    private(set) var id: UUID = UUID()
    private(set) var coordinate: Point

    init(coordinate: Point) {
        self.coordinate = coordinate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        lhs.id == rhs.id
    }

    func moveObject(to coord: Point) {
        self.coordinate = coord
    }
}
