import SwiftUI

struct DimensionLine: View {
  var color: Color
  let lineWidth: CGFloat
  let arrowHeight: CGFloat
  let lineHeight: CGFloat

  init(_ color: Color = Color.cyan, _ lineWidth: CGFloat = 2, _ arrowHeight: CGFloat = 12, _ lineHeight: CGFloat = 24) {
    self.color = color
    self.lineWidth = lineWidth
    self.arrowHeight = arrowHeight
    self.lineHeight = lineHeight
  }

  var body: some View {
    DoubleArrow(color: color)
      .frame(height: arrowHeight)
      .overlay(
        VerticalLine()
          .stroke(color, lineWidth: lineWidth)
          .frame(height: lineHeight)
      )
      .overlay(
        VerticalLine().flippedX()
          .stroke(color, lineWidth: lineWidth)
          .frame(height: lineHeight)
      )
  }
}
