import SwiftUI

struct ArrowHead: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    let arrowWidth = rect.height
    if arrowWidth >= rect.width / 2 {
      return path
    }

    path.move(to: CGPoint(x: rect.minX + arrowWidth, y: rect.minY))

    path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))

    path.addLine(to: CGPoint(x: rect.minX + arrowWidth, y: rect.maxY))

    return path
  }
}
