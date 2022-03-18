import SwiftUI

struct CannonballView: View {

    private let position: CGPoint
    private let radius: CGFloat
    private let diameter: CGFloat

    init(withCannonball cannonball: Cannonball) {
        self.position = CGPoint(x: cannonball.coordinate.xCoord,
                                y: cannonball.coordinate.yCoord)
        self.radius = cannonball.radius
        self.diameter = cannonball.diameter

    }

    var body: some View {
        Image("ball")
            .resizable()
            .frame(width: diameter, height: diameter)
            .position(position)
    }
}

struct CannonballView_Previews: PreviewProvider {
    static var previews: some View {
        CannonballView(withCannonball: Cannonball(coordinate:
                                                    Point(xCoord: UIScreen.main.bounds.midX,
                                                          yCoord: UIScreen.main.bounds.midY)))
    }
}
