import SwiftUI

extension View {
    var screenBounds: Rect {
        do {
            let rect = try Rect(minX: UIScreen.main.bounds.minX,
                            maxX: UIScreen.main.bounds.maxX,
                            minY: UIScreen.main.bounds.minY,
                            maxY: UIScreen.main.bounds.maxY)
            return rect
        } catch {
            assert(false, "Screen bounds rectangle could not be made")
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
