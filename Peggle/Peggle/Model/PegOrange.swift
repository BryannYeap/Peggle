class PegOrange: PegObstacle {
    func getDeepCopyPegOrange() -> PegOrange {
        PegOrange(isBlock: false,
                  radius: self.radius,
                  coordinate: self.coordinate)
    }
}
