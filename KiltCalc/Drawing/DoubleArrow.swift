import SwiftUI

struct DoubleArrow: View {
  var color: Color

  var body: some View {
    HorizontalLine()
      .stroke(color, lineWidth: 2)
      .overlay(
        ArrowHead()
          .stroke(color, lineWidth: 2)
      )
      .overlay(
        ArrowHead()
          .flippedX()
          .stroke(color, lineWidth: 2)
      )
  }
}
