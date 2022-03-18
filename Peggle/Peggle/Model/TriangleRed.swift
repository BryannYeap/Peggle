class TriangleRed: TriangleObstacle {
    func getDeepCopyTriangleRed() -> TriangleRed {
        TriangleRed(isBlock: self.isBlock,
                    width: self.width,
                    height: self.height,
                    coordinate: self.coordinate)
    }
}
