import SwiftUI

struct VerticalLine: Shape {
  let xPercent: CGFloat

  init(_ xPercent: CGFloat = 0.0) {
    self.xPercent = xPercent
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.xPercent(xPercent), y: rect.minY))
    path.addLine(to: CGPoint(x: rect.xPercent(xPercent), y: rect.maxY))
    return path
  }
}
