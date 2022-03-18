import SwiftUI

struct ButtonView: View {

    private var buttonText: String
    private var color: Color
    private var action: () -> Void

    init(buttonText: String, color: Color, action: @escaping () -> Void) {
        self.buttonText = buttonText
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(buttonText) {
            action()
        }.padding(.trailing, 5)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .font(.headline)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 4))
            .background(color)
            .cornerRadius(25)
            .foregroundColor(.black)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonText: "Test Button", color: .red, action: {})
    }
}
