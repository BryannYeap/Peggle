class PegBlue: PegObstacle {
    func getDeepCopyPegBlue() -> PegBlue {
        PegBlue(isBlock: false,
                radius: self.radius,
                coordinate: self.coordinate)
    }
}
