protocol GameEngine: AnyObject {
    var gameLoop: GameLoop { get }
    func update(_ timeInterval: Double)
    func render(lag: Double)
}
