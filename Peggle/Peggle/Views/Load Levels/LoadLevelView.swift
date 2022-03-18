import SwiftUI

struct LoadLevelView: View {

    @ObservedObject private var viewModel: LoadLevelViewModel
    private let showMenuUponStartUp: Bool

    init(viewModel: LoadLevelViewModel = .init(), showMenuUponStartUp: Bool = true) {
        self.viewModel = viewModel
        self.showMenuUponStartUp = showMenuUponStartUp
        UINavigationBar.appearance().backgroundColor = .systemBlue
        UINavigationBar.appearance().barTintColor = .systemBlue
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.getSavedCollectionOfLevels) { level in

                    let levelDesignerViewModelForThisLevel =
                    LevelDesignerViewModel(isNewLevel: false,
                                           level: level,
                                           savedLevels: viewModel.savedLevels,
                                           levelBounds: screenBounds)
                    let levelDesignerViewForThisLevel = LevelDesignerView(viewModel: levelDesignerViewModelForThisLevel)
                    NavigationLink(level.id, destination: levelDesignerViewForThisLevel)

                }.onDelete(perform: { indexSet in
                    viewModel.deleteLevel(at: indexSet)
                })

                if viewModel.hasNoSavedLevels() {
                    Text("No Levels Currently Saved")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.gray)
                }

            }.navigationTitle("LEVELS")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    NavBarView(viewModel: viewModel,
                               showMenuUponStartUp: showMenuUponStartUp)
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoadLevelView_Previews: PreviewProvider {
    static var previews: some View {
        LoadLevelView()
    }
}
