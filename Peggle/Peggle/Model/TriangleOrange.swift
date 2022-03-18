class TriangleOrange: TriangleObstacle {
    func getDeepCopyTriangleOrange() -> TriangleOrange {
        TriangleOrange(isBlock: self.isBlock,
                       width: self.width,
                       height: self.height,
                       coordinate: self.coordinate)
    }
}
