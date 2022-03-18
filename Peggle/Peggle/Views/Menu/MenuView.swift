import SwiftUI

struct MenuView: View {

    @Environment(\.presentationMode) var presentationMode
    private var viewModel: LoadLevelViewModel

    init(viewModel: LoadLevelViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {

            BackgroundView()

            VStack {

                TextFontView(text: "~~~PEGGLE~~~",
                             colour: .indigo,
                             fontSize: 80,
                             design: .serif)

                Spacer()

                VStack {

                    TextFontView(text: "MAIN MENU",
                                 colour: .accentColor,
                                 fontSize: 40,
                                 design: .serif)

                    NavLinkButtonView(buttonText: "Design New Level",
                                      color: .teal,
                                      destinationView: LevelDesignerView(
                        viewModel: LevelDesignerViewModel(isNewLevel: true,
                                                          level: Level(),
                                                          savedLevels: viewModel.savedLevels,
                                                          levelBounds: screenBounds)))

                    Button("Load Levels") {
                        presentationMode.wrappedValue.dismiss()
                    }.padding(.trailing, 5)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .font(.headline)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 4))
                        .background(.brown)
                        .cornerRadius(25)
                        .foregroundColor(.black)
                        .padding()

                }.background(Color.yellow.opacity(0.4))

                Spacer()
                Spacer()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
