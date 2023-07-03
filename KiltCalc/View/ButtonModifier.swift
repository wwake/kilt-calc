import SwiftUI

public struct ButtonModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color("KeyColor"))
          .shadow(color: .gray, radius: 2, x: 3, y: 3)
      )
  }
}

extension View {
  public func buttonFormat() -> some View {
    modifier(ButtonModifier())
  }
}
