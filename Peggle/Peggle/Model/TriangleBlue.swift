class TriangleBlue: TriangleObstacle {
    func getDeepCopyTriangleBlue() -> TriangleBlue {
        TriangleBlue(isBlock: self.isBlock,
                     width: self.width,
                     height: self.height,
                     coordinate: self.coordinate)
    }
}
