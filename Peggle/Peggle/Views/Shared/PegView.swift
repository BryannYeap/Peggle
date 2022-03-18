import SwiftUI

struct PegView: View {

    private let colour: PegView.Colour
    private let position: CGPoint
    private let radius: CGFloat

    init(colour: PegView.Colour,
         withPeg peg: PegObstacle) {
        self.colour = colour
        self.position = CGPoint(x: peg.coordinate.xCoord,
                                y: peg.coordinate.yCoord)
        self.radius = peg.radius
    }

    var body: some View {
        Image(colour.rawValue)
                .resizable()
                .frame(width: radius * 2, height: radius * 2)
                .position(position)
    }

    enum Colour: String {
        case blue = "peg-blue"
        case orange = "peg-orange"
        case green = "peg-green"
        case blueGlow = "peg-blue-glow"
        case orangeGlow = "peg-orange-glow"
        case greenGlow = "peg-green-glow"
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView(colour: PegView.Colour.blue,
                withPeg: PegObstacle(coordinate: Point(xCoord: UIScreen.main.bounds.midX,
                                               yCoord: UIScreen.main.bounds.midY)))
    }
}
