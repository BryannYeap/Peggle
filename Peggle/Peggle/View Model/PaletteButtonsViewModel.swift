import Foundation

class PaletteButtonsViewModel: ObservableObject {

    let selectedIndicatorAlpha: Double = 1.0
    let unselectedIndicatorAlpha: Double = 0.35

    @Published private(set) var selectedButton: PaletteButtonsViewModel.SelectedButton

    init() {
        self.selectedButton = SelectedButton.bluePeg
    }

    func tapButton(_ button: SelectedButton) {
        guard selectedButton != button else {
            selectButton(SelectedButton.none)
            return
        }

        selectButton(button)
    }

    func unselectAllButtons() {
        selectButton(SelectedButton.none)
    }
}

extension PaletteButtonsViewModel {

    enum SelectedButton {
        case resize,
             bluePeg,
             orangePeg,
             greenPeg,
             blueTriangle,
             orangeTriangle,
             greenTriangle,
             redTriangle,
             delete,
             none
    }

    private func selectButton(_ button: SelectedButton) {
        selectedButton = button
    }

}
