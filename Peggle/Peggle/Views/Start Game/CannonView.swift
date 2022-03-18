import SwiftUI

struct CannonView: View {

    @ObservedObject private var viewModel: StartGameViewModel

    private let height: Double = 150
    private let width: Double = 150

    var position: CGPoint {
        CGPoint(x: viewModel.cannonPosition.xCoord,
                y: viewModel.cannonPosition.yCoord)
    }

    init(viewModel: StartGameViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        Image("cannon-default")
            .resizable()
            .frame(width: width, height: height)
            .rotationEffect(.radians(viewModel.cannonRotation))
    }

    mutating func setViewModel(viewModel: StartGameViewModel) {
        self.viewModel = viewModel
    }
}

struct CannonView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView()
    }
}
