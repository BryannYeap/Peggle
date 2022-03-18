import SwiftUI

struct StartGameView: View {

    @ObservedObject private var viewModel: StartGameViewModel
    @State private var animationColour: Color = .red

    // Timer is set to 1 minute and 45 seconds
    @State private var timeRemaining = 105

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let spookyBallMessage = "SPOOKY BALL!!"
    private let kaboomMessage = "KA BOOOOOOM!!"

    init(viewModel: StartGameViewModel = .init(), hasStartedGame: Bool = false) {
        self.viewModel = viewModel
        if hasStartedGame {
            startGame()
        }
    }

    func updateViewModelAndStartGame(viewModel: LevelDesignerViewModel) -> StartGameView {
        let startGameViewModel = StartGameViewModel(level: viewModel.level,
                                                    gameBounds: screenBounds,
                                                    powerup: viewModel.chosenPower ?? .spooky)
        startGameViewModel.setDelegate(viewModelDelegate: viewModel)
        return StartGameView(viewModel: startGameViewModel, hasStartedGame: true)
    }

    func startGame() {
        viewModel.startGame()
    }

    var body: some View {

        ZStack {
            CanvasView(viewModel: viewModel)
            BucketView(viewModel: viewModel)
            VStack {
                if viewModel.spookyBallsLeft > 0 {
                    TextFontView(text: spookyBallMessage,
                                 colour: animationColour,
                                 fontSize: 60.0 - (Double(timeRemaining).truncatingRemainder(dividingBy: 2)) * 10.0,
                                 design: .rounded)
                }

                if viewModel.justExploded {
                    TextFontView(text: kaboomMessage,
                                 colour: animationColour,
                                 fontSize: 60.0 - (Double(timeRemaining).truncatingRemainder(dividingBy: 2)) * 10.0,
                                 design: .rounded)
                }
                Spacer()
                HStack {

                    VStack {

                        TextFontView(text: "Score: \(viewModel.score)",
                                     colour: .black,
                                     fontSize: 20,
                                     design: .serif)
                            .padding(.bottom, -40)

                        TextFontView(text: "Multiplier: \(viewModel.multiplier)x",
                                     colour: .black,
                                     fontSize: 20,
                                     design: .serif)
                            .padding(.bottom, -40)
                    }.padding(.bottom, -20)

                Spacer()

                TextFontView(text: "\(timeRemaining)",
                             colour: .red,
                             fontSize: 60,
                             design: .serif)
                        .padding(.bottom, -20)
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                                animationColour = animationColour == .red ? .white : .red
                            } else {
                                viewModel.processWinLoseConditions()
                            }

                            if viewModel.kaboomMessageTimer > 0 {
                                viewModel.kaboomMessageTimer -= 1
                            } else {
                                viewModel.justExploded = false
                            }
                        }
                }
                HStack {

                    ButtonView(buttonText: "Quit Playing",
                               color: .red,
                               action: viewModel.endGame)

                    Spacer()

                    if viewModel.powerup == .spooky {
                        TextFontView(text: "Spooky balls: \(viewModel.spookyBallsLeft)",
                                     colour: .black,
                                     fontSize: 20,
                                     design: .serif)
                    }

                    TextFontView(text: "Orange obstacles: \(viewModel.orangeObstaclesLeft)",
                                 colour: .black,
                                 fontSize: 20,
                                 design: .serif)

                    TextFontView(text: "Cannonballs: \(viewModel.cannonballsLeft)",
                                 colour: .black,
                                 fontSize: 20,
                                 design: .serif)
                }
            }
        }.alert("Congratulations! You have won the game with a score of \(viewModel.score)! :)",
                isPresented: $viewModel.gameIsWon) {
            Button("OK", role: .cancel) {
                viewModel.endGame()
            }
        }.alert("Sorry! You have lost the game with a score of \(viewModel.score) :(",
                isPresented: $viewModel.gameIsLost) {
            Button("OK", role: .cancel) {
                viewModel.endGame()
            }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
