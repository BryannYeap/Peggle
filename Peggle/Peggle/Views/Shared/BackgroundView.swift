import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("background")
            .resizable()
            .padding([.leading, .trailing], -250)
            .clipped()
            .background(Color.yellow.opacity(0.6))
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
