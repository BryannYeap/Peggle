import SwiftUI

struct PaletteView: View {

    static let height: CGFloat = 150
    static let paletteEdgeBuffer: CGFloat = 1.5

    private var viewModel: LevelDesignerViewModel

    init(viewModel: LevelDesignerViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { _ in
            VStack {
                PaletteButtonsView(viewModel: viewModel.paletteButtonsViewModel)
                ActionButtonsView(viewModel: viewModel)
            }
        }.frame(height: PaletteView.height)
            .background(.white)
            .padding(.bottom)
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView()
    }
}
