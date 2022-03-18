import SwiftUI

struct LevelDesignerView: View {

    @ObservedObject private var viewModel: LevelDesignerViewModel
    private var startGameView: StartGameView

    init(viewModel: LevelDesignerViewModel = .init()) {
        self.viewModel = viewModel
        self.startGameView = StartGameView()
    }

    var body: some View {
        ZStack {
            VStack {
                CanvasView(viewModel: viewModel)
                PaletteView(viewModel: viewModel)
            }
            VStack {
                TextFontView(text: "Orange obstacles placed: \(viewModel.numberOfOrangeObstaclesPlaced)",
                             colour: .black,
                             fontSize: 25,
                             design: .serif)
                    .position(x: screenBounds.midX, y: screenBounds.maxY
                              - PaletteView.height * PaletteView.paletteEdgeBuffer + 20)
            }

            if viewModel.gameInPlay {
                startGameView.updateViewModelAndStartGame(viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LevelDesignerView()
        }
    }
}
