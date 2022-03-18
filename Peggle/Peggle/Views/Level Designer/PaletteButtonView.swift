import SwiftUI

struct PaletteButtonView: View {

    @ObservedObject private var viewModel: PaletteButtonsViewModel
    private let imageName: String
    private let paletteButton: PaletteButtonsViewModel.SelectedButton

    init(viewModel: PaletteButtonsViewModel = .init(),
         imageName: String,
         paletteButton: PaletteButtonsViewModel.SelectedButton) {
        self.viewModel = viewModel
        self.imageName = imageName
        self.paletteButton = paletteButton
    }

    var body: some View {

            Image(imageName)
                .opacity(viewModel.selectedButton == paletteButton
                         ? viewModel.selectedIndicatorAlpha
                         : viewModel.unselectedIndicatorAlpha)
                .onTapGesture {
                    hideKeyboard()
                    viewModel.tapButton(paletteButton)
                }

    }
}

struct PegButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonView(imageName: "blue-peg",
                          paletteButton: .bluePeg)
    }
}
