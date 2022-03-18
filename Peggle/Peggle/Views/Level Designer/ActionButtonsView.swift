import SwiftUI

struct ActionButtonsView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var levelName: String = ""
    @State private var levelSaved: Bool = false
    @State private var levelNameIsInvalid: Bool = false
    @State private var errorMessage: String = ""
    @State private var startPressed: Bool = false

    private var viewModel: LevelDesignerViewModel

    init(viewModel: LevelDesignerViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {

        HStack {
            Button("BACK") {
                presentationMode.wrappedValue.dismiss()
            }

            Button("SAVE") {
                do {
                    try viewModel.saveLevel(as: levelName.trimmingCharacters(in: .whitespaces))
                    levelName = ""
                    levelSaved = true
                } catch PeggleError.noNameError(let noNameErrorMessage) {
                    levelNameIsInvalid = true
                    errorMessage = noNameErrorMessage
                } catch PeggleError.nameExistsError(let nameExistsErrorMessage) {
                    levelNameIsInvalid = true
                    errorMessage = nameExistsErrorMessage
                } catch {
                    assert(false, "Unexpected error thrown in ActionButtonsView")
                }
                hideKeyboard()
            }.alert(errorMessage,
                    isPresented: $levelNameIsInvalid) {
                Button("OK", role: .cancel) {}
            }.alert("Level has been saved!", isPresented: $levelSaved) {
                Button("OK", role: .cancel) {}
            }

            Button("RESET") {
                viewModel.removeAllPegs()
                hideKeyboard()
            }

            TextField(viewModel.isNewLevel ? "Level Name" : viewModel.nameOfLevel,
                      text: $levelName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 30)
                .padding(.bottom)

            Button("START") {
                startPressed = true
                hideKeyboard()
            }.alert("Choose a powerup", isPresented: $startPressed) {
                Button("Spooky Ball") {
                    viewModel.choosePowerup(.spooky)
                    viewModel.startGame()
                }
                Button("Ka-Boom") {
                    viewModel.choosePowerup(.kaboom)
                    viewModel.startGame()
                }
                Button("CANCEL", role: .cancel) {}
            }

        }.frame(height: 20)
            .foregroundColor(.blue)
            .padding(.horizontal)
    }
}

struct ActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonsView()
    }
}
