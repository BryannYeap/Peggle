import SwiftUI

struct TriangleView: View {

    private let colour: TriangleView.Colour
    private var isBlock: Bool
    private let position: CGPoint
    private let width: Double
    private let height: Double

    @ObservedObject var viewModel: LevelDesignerViewModel
    @State var isChoosingSpringConstant: Bool = false

    init(viewModel: LevelDesignerViewModel = .init(),
         colour: TriangleView.Colour,
         withTriangle triangle: TriangleObstacle) {
        self.viewModel = viewModel
        self.colour = colour
        self.isBlock = triangle.isBlock
        self.position = CGPoint(x: triangle.coordinate.xCoord,
                                y: triangle.coordinate.yCoord)
        self.width = triangle.width
        self.height = triangle.height
    }

    var body: some View {
        ZStack {
            Image(colour.rawValue)
                    .resizable()
                    .frame(width: width, height: height)
        }.position(position)
    }

    enum Colour: String {
        case blue = "peg-blue-triangle"
        case orange = "peg-orange-triangle"
        case green = "peg-green-triangle"
        case red = "peg-red-triangle"
        case blueGlow = "peg-blue-glow-triangle"
        case orangeGlow = "peg-orange-glow-triangle"
        case greenGlow = "peg-green-glow-triangle"
        case redGlow = "peg-red-glow-triangle"
    }
}

struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView(colour: TriangleView.Colour.red,
                     withTriangle: TriangleObstacle(isBlock: true,
                                                    width: 100,
                                                    height: 100,
                                                    coordinate: Point(xCoord: UIScreen.main.bounds.midX,
                                                                      yCoord: UIScreen.main.bounds.midY)))
    }
}
