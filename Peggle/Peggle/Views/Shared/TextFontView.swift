import SwiftUI

struct TextFontView: View {

    private let text: String
    private let colour: Color
    private let fontSize: Double
    private let design: Font.Design

    init(text: String = "", colour: Color = .black, fontSize: Double = 40, design: Font.Design = .rounded) {
        self.text = text
        self.colour = colour
        self.fontSize = fontSize
        self.design = design
    }

    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .font(.system(size: fontSize, design: design))
            .foregroundColor(colour)
            .padding()
    }
}

struct TextFontView_Previews: PreviewProvider {
    static var previews: some View {
        TextFontView()
    }
}
