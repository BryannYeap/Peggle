class PegGreen: PegObstacle {
    func getDeepCopyPegGreen() -> PegGreen {
        PegGreen(isBlock: false,
                 radius: self.radius,
                 coordinate: self.coordinate)
    }
}
