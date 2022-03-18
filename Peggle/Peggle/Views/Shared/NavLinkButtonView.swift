import SwiftUI

struct NavLinkButtonView<DestinationView>: View where DestinationView: View {

    @State private var isActive: Bool
    private let buttonText: String
    private let color: Color
    private let destinationView: DestinationView

    init(buttonText: String, color: Color, destinationView: DestinationView, isActive: Bool = false) {
        self.buttonText = buttonText
        self.color = color
        self.destinationView = destinationView
        _isActive = State(initialValue: isActive)
    }

    var body: some View {
        NavigationLink(buttonText,
                       destination: destinationView.navigationBarHidden(true),
                       isActive: $isActive)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .font(.headline)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 4))
            .background(color)
            .cornerRadius(25)
            .foregroundColor(.black)
    }
}

struct NavLinkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavLinkButtonView(buttonText: "Testing",
                          color: .cyan,
                          destinationView: CannonballView(withCannonball: Cannonball()))
    }
}
