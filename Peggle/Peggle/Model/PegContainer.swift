struct PegContainer: Codable {

    private var bluePegs: [PegBlue]
    private var orangePegs: [PegOrange]
    private var greenPegs: [PegGreen]

    init(bluePegs: [PegBlue] = [],
         orangePegs: [PegOrange] = [],
         greenPegs: [PegGreen] = []) {
        self.bluePegs = bluePegs
        self.orangePegs = orangePegs
        self.greenPegs = greenPegs
    }

    var numberOfOrangePegs: Int {
        orangePegs.count
    }

    mutating func addPeg(_ peg: PegObstacle) {
        if let bluePeg = peg as? PegBlue {
            bluePegs.append(bluePeg)
        } else if let orangePeg = peg as? PegOrange {
            orangePegs.append(orangePeg)
        } else if let greenPeg = peg as? PegGreen {
            greenPegs.append(greenPeg)
        } else {
            assert(false, "Attempting to add a type of peg that cannot be determined in peg container")
        }
    }

    mutating func removeAllPegs(where shouldBeRemoved: (PegObstacle) -> Bool ) {
        bluePegs.removeAll(where: shouldBeRemoved)
        orangePegs.removeAll(where: shouldBeRemoved)
        greenPegs.removeAll(where: shouldBeRemoved)
    }

    mutating func movePeg(_ peg: PegObstacle, to coord: Point) {
        peg.movePeg(to: coord)
    }

    mutating func removeAllPegs() {
        bluePegs = []
        orangePegs = []
        greenPegs = []
    }

    func getPegs() -> [PegObstacle] {
        var pegs: [PegObstacle] = []
        pegs.append(contentsOf: bluePegs)
        pegs.append(contentsOf: orangePegs)
        pegs.append(contentsOf: greenPegs)
        return pegs
    }

    func getDeepCopy() -> PegContainer {
        var bluePegsCopy: [PegBlue] = []
        var orangePegsCopy: [PegOrange] = []
        var greenPegsCopy: [PegGreen] = []

        for bluePeg in bluePegs {
            bluePegsCopy.append(bluePeg.getDeepCopyPegBlue())
        }

        for orangePeg in orangePegs {
            orangePegsCopy.append(orangePeg.getDeepCopyPegOrange())
        }

        for greenPeg in greenPegs {
                greenPegsCopy.append(greenPeg.getDeepCopyPegGreen())
        }

        return PegContainer(bluePegs: bluePegsCopy, orangePegs: orangePegsCopy, greenPegs: greenPegsCopy)
    }
}
