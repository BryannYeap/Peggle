class TriangleGreen: TriangleObstacle {
    func getDeepCopyTriangleGreen() -> TriangleGreen {
        TriangleGreen(isBlock: self.isBlock,
                      width: self.width,
                      height: self.height,
                      coordinate: self.coordinate)
    }
}
