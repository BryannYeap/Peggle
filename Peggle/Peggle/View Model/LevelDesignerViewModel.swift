import Foundation

class LevelDesignerViewModel: CanvasViewModel {

    private let levelBounds: Rect

    private(set) var isNewLevel: Bool
    private(set) var paletteButtonsViewModel: PaletteButtonsViewModel
    private(set) var chosenPower: Powerup?
    private var savedLevels: SavedLevels

    @Published private(set) var gameInPlay: Bool
    @Published private(set) var level: Level

    var nameOfLevel: String {
        level.id
    }

    override var levelGameObjects: [GameObject] {
        level.getGameObjects()
    }

    var isPreloadedLevel: Bool {
        level.isPreloadedLevel
    }

    var selectedButton: PaletteButtonsViewModel.SelectedButton {
        paletteButtonsViewModel.selectedButton
    }

    var numberOfOrangeObstaclesPlaced: Int {
        level.getNumberOfOrangeObstacles()
    }

    init(isNewLevel: Bool = true,
         level: Level = .init(),
         savedLevels: SavedLevels = .init(),
         levelBounds: Rect = .zero) {
        self.gameInPlay = false
        self.isNewLevel = isNewLevel
        self.level = level
        self.savedLevels = savedLevels
        self.paletteButtonsViewModel = PaletteButtonsViewModel()
        self.levelBounds = levelBounds
    }

    override func backgroundOnTapGesture(at coord: Point) {
        addObstacle(at: coord)
    }

    private func addObstacle(at coord: Point) {
        guard selectedButton != PaletteButtonsViewModel.SelectedButton.none else {
            return
        }

        var obstacle: Obstacle?

        if selectedButton == PaletteButtonsViewModel.SelectedButton.bluePeg {
            obstacle = PegBlue(isBlock: false, coordinate: coord)
        } else if selectedButton == PaletteButtonsViewModel.SelectedButton.orangePeg {
            obstacle = PegOrange(isBlock: false, coordinate: coord)
        } else if selectedButton == PaletteButtonsViewModel.SelectedButton.greenPeg {
            obstacle = PegGreen(isBlock: false, coordinate: coord)
        } else if selectedButton == PaletteButtonsViewModel.SelectedButton.blueTriangle {
            obstacle = TriangleBlue(isBlock: false, coordinate: coord)
        } else if selectedButton == PaletteButtonsViewModel.SelectedButton.orangeTriangle {
            obstacle = TriangleOrange(isBlock: false, coordinate: coord)
        } else if selectedButton == PaletteButtonsViewModel.SelectedButton.greenTriangle {
            obstacle = TriangleGreen(isBlock: false, coordinate: coord)
        } else if selectedButton == PaletteButtonsViewModel.SelectedButton.redTriangle {
            obstacle = TriangleRed(isBlock: true, coordinate: coord)
        }

        guard let obstacleToAdd = obstacle, isValidState(for: obstacleToAdd) else {
            return
        }

        level.addGameObject(obstacleToAdd)
    }

    override func obstacleOnTapGesture(_ obstacle: Obstacle?) {
        guard let obstacle = obstacle else {
            return
        }

        removeObstacleWithTap(obstacle)
    }

    private func removeObstacleWithTap(_ obstacle: Obstacle) {
        guard selectedButton == PaletteButtonsViewModel.SelectedButton.delete else {
            return
        }
        level.removeGameObject(obstacle)
    }

    override func obstacleOnLongPressGesture(_ obstacle: Obstacle?) {
        guard let obstacle = obstacle else {
            return
        }

        removeGameObjectWithLongPress(obstacle)
    }

    private func removeGameObjectWithLongPress(_ obstacle: Obstacle?) {
        guard let obstacle = obstacle else {
            return
        }

        guard selectedButton != PaletteButtonsViewModel.SelectedButton.resize else {
            return
        }

        level.removeGameObject(obstacle)
    }

    override func obstacleOnDragGesture(obstacle: Obstacle?, coord: Point) {
        guard let obstacle = obstacle else {
            return
        }

        moveObstacle(obstacle, to: coord)
        resizeObstacle(obstacle, towards: coord)
        changeSpringConstant(obstacle, towards: coord)
    }

    private func moveObstacle(_ obstacle: Obstacle, to coord: Point) {
        guard selectedButton != PaletteButtonsViewModel.SelectedButton.resize
                && selectedButton != PaletteButtonsViewModel.SelectedButton.none else {
            return
        }

        let oldObstacle = obstacle.getDeepCopy()
        level.moveGameObject(obstacle, to: coord)
        if !isValidState(for: obstacle) {
            obstacle.obtainState(from: oldObstacle)
        }
    }

    private func resizeObstacle(_ obstacle: Obstacle, towards coord: Point) {
        guard selectedButton == PaletteButtonsViewModel.SelectedButton.resize else {
            return
        }

        let oldObstacle = obstacle.getDeepCopy()
        level.resizeObstacle(obstacle, towards: coord)
        if !isValidState(for: obstacle) {
            obstacle.obtainState(from: oldObstacle)
        }
    }

    private func changeSpringConstant(_ obstacle: Obstacle, towards coord: Point) {
        guard obstacle.isBlock && selectedButton == PaletteButtonsViewModel.SelectedButton.none else {
            return
        }

        level.changeSpringConstant(obstacle, towards: coord)
    }

    override func backgroundOnDragGesture(_ coord: Point) {
        for levelGameObject in levelGameObjects {
            level.moveGameObject(levelGameObject, to: Point(xCoord: levelGameObject.coordinate.xCoord,
                                                            yCoord: levelGameObject.coordinate.yCoord))
        }
    }

    func removeAllPegs() {
        level.removeAll()
    }

    private func isValidState(for obstacle: Obstacle) -> Bool {
        isWithinCanvas(obstacle: obstacle) && noOtherObstaclesNear(obstacle: obstacle)
    }

    private func isWithinCanvas(obstacle: Obstacle) -> Bool {
        notPastLeftEdgeOfCanvas(obstacle: obstacle) &&
        notPastRightEdgeOfCanvas(obstacle: obstacle) &&
        notPastTopEdgeOfCanvas(obstacle: obstacle) &&
        notPastBottomEdgeOFCanvas(obstacle: obstacle)
    }

    private func notPastLeftEdgeOfCanvas(obstacle: Obstacle) -> Bool {
        obstacle.isFullyToTheRight(of: levelBounds.minX)
    }

    private func notPastRightEdgeOfCanvas(obstacle: Obstacle) -> Bool {
        obstacle.isFullyToTheLeft(of: levelBounds.maxX)
    }

    private func notPastTopEdgeOfCanvas(obstacle: Obstacle) -> Bool {
        obstacle.isFullyBelow(of: levelBounds.minY)
    }

    private func notPastBottomEdgeOFCanvas(obstacle: Obstacle) -> Bool {
        return obstacle.isFullyAbove(of: levelBounds.maxY - (PaletteView.height * PaletteView.paletteEdgeBuffer))
    }

    private func noOtherObstaclesNear(obstacle: Obstacle) -> Bool {
        for gameObject in levelGameObjects where gameObject !== obstacle {
            if let otherObstacle = gameObject as? Obstacle,
               otherObstacle.isIntersecting(with: obstacle) {
                return false
            }
        }

        return true
    }

    func saveLevel(as nameOfLevel: String) throws {

        guard !(isPreloadedLevel && nameOfLevel.isEmpty) else {
            throw PeggleError.nameExistsError("You are trying to modify a preloaded level. " +
                                              "Please a enter different level name than the preloaded level name")
        }

        guard !(isNewLevel && nameOfLevel.isEmpty) else {
            throw PeggleError.noNameError("Level name cannot be blank. Please choose a name for this level")
        }

        guard !savedLevels.hasLevelWithName(name: nameOfLevel) else {
            throw PeggleError.nameExistsError("A level with that name already exists. Please choose a different name")
        }

        if isPreloadedLevel {
            var copyOfLevel = level.getDeepCopy()
            copyOfLevel.setName(as: nameOfLevel)
            savedLevels.addLevel(level: copyOfLevel)
        } else if isNewLevel {
            isNewLevel = false
            level.setName(as: nameOfLevel)
            savedLevels.addLevel(level: level)
        } else {
            let nameOfUpdatedLevel = nameOfExistingLevelToBeUpdated(to: nameOfLevel)
            let oldName = level.id
            level.setName(as: nameOfUpdatedLevel)
            savedLevels.updateLevel(withOldName: oldName, level: level)
        }
    }

    private func nameOfExistingLevelToBeUpdated(to name: String) -> String {
        guard !name.isEmpty else {
            return level.id
        }
        return name
    }

    func startGame() {
        gameInPlay = true
    }

    func endGame() {
        level.resetObstacles()
        gameInPlay = false
    }

    func choosePowerup(_ powerup: Powerup) {
        self.chosenPower = powerup
    }

    func obtainOscillatingCircleWidth(for obstacle: Obstacle) -> Double {
        guard obstacle.oscillatingSpringConstant != obstacle.nonOscillatableSpringConstant else {
            return sqrt(obstacle.minimumOscillatingSpringConstant) * 2
        }

        return sqrt(obstacle.oscillatingSpringConstant) * 2
    }
}

extension LevelDesignerViewModel: StartGameViewModelDelegate {

    func didEndGame() {
        endGame()
    }

}
