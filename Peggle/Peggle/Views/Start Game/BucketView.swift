import SwiftUI

struct BucketView: View {

    @ObservedObject private var viewModel: StartGameViewModel

    init(viewModel: StartGameViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        Image("bucket")
            .resizable()
            .frame(width: viewModel.bucket.width, height: viewModel.bucket.height)
            .position(CGPoint(x: viewModel.bucket.coordinate.xCoord,
                              y: viewModel.bucket.coordinate.yCoord))
            .gesture(DragGesture().onChanged({ value in
                viewModel.obstacleOnDragGesture(obstacle: nil,
                                                coord: Point(xCoord: value.location.x,
                                                             yCoord: value.location.y))
                hideKeyboard()
            })).gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                viewModel.obstacleOnTapGesture(nil)
                viewModel.backgroundOnTapGesture(at: Point(xCoord: value.location.x, yCoord: value.location.y))
                hideKeyboard()
            }))
    }
}

struct BucketView_Previews: PreviewProvider {
    static var previews: some View {
        BucketView()
    }
}
