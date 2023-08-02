import SwiftUI

struct AdjustedHipStyle: ViewModifier {
  let adjustedHip: Value?
  let hipWasAdjusted: Bool

  init(_ adjustedHip: Value?, _ hipWasAdjusted: Bool) {
    self.adjustedHip = adjustedHip
    self.hipWasAdjusted = hipWasAdjusted
  }

  func body(content: Content) -> some View {
    var color = Color.black

    if adjustedHip == nil {
      color = Color.gray
    } else if hipWasAdjusted {
      color = Color.red
    }

    return content
      .bold(hipWasAdjusted)
      .foregroundColor(color)
  }
}

extension View {
  func adjustedHipStyle(_ adjustedHip: Value?, _ hipWasAdjusted: Bool) -> some View {
    modifier(AdjustedHipStyle(adjustedHip, hipWasAdjusted))
  }
}
