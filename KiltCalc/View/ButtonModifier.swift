import SwiftUI

public struct ButtonModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .background(Color("KeyColor"))
      .border(Color("AccentColor"), width: 1)
  }
}

extension View {
  public func buttonFormat() -> some View {
    modifier(ButtonModifier())
  }
}
