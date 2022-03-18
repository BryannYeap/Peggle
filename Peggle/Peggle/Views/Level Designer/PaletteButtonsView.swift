import SwiftUI

struct PaletteButtonsView: View {

    @ObservedObject private var viewModel: PaletteButtonsViewModel

    init(viewModel: PaletteButtonsViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {

            ZStack {
                PaletteButtonView(viewModel: viewModel,
                                  imageName: "peg-purple",
                                  paletteButton: PaletteButtonsViewModel.SelectedButton.resize)
                TextFontView(text: "RESIZE",
                             colour: .black,
                             fontSize: 25,
                             design: .rounded)
            }.frame(width: 25, height: 25)
                .padding(.leading, -115)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-blue",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.bluePeg)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-orange",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.orangePeg)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-green",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.greenPeg)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-blue-triangle",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.blueTriangle)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-orange-triangle",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.orangeTriangle)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-green-triangle",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.greenTriangle)

            PaletteButtonView(viewModel: viewModel,
                              imageName: "peg-red-triangle",
                              paletteButton: PaletteButtonsViewModel.SelectedButton.redTriangle)

            Image("delete")
                .resizable()
                .opacity(viewModel.selectedButton ==
                                      PaletteButtonsViewModel.SelectedButton.delete
                                      ? viewModel.selectedIndicatorAlpha
                                      : viewModel.unselectedIndicatorAlpha)
                .scaledToFit()
                .frame(width: 150, height: 135)
                .onTapGesture {
                    hideKeyboard()
                    viewModel.tapButton(PaletteButtonsViewModel.SelectedButton.delete)
                }

        }.padding([.top, .bottom], -5)
            .padding(.trailing, -400)
            .scaleEffect(0.50)

    }
}

struct PegButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonsView()
    }
}
