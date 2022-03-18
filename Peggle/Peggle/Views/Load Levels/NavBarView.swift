import SwiftUI

struct NavBarView: View {

    private var viewModel: LoadLevelViewModel
    private var showMenuUponStartUp: Bool

    init(viewModel: LoadLevelViewModel = .init(), showMenuUponStartUp: Bool = false) {
        self.viewModel = viewModel
        self.showMenuUponStartUp = showMenuUponStartUp
    }

    var body: some View {
        HStack {
            NavLinkButtonView(buttonText: "Return To Start Menu",
                              color: .yellow,
                              destinationView: MenuView(viewModel: viewModel),
                              isActive: showMenuUponStartUp)

            ButtonView(buttonText: "Delete All Levels",
                       color: .red,
                       action: viewModel.deleteAllLevels)
        }
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}
