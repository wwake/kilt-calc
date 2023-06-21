import SwiftUI

public struct ValueModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .padding(4)
      .frame(width: 330, alignment: .trailing)
      .background(Color.white)
      .border(Color.black)
  }
}

extension View {
  public func valueFormat() -> some View {
    modifier(ValueModifier())
  }
}
