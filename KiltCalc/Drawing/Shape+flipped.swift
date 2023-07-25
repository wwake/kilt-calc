import SwiftUI

extension Shape {
  func flippedX() -> ScaledShape<Self> {
    scale(x: -1, y: 1, anchor: .center)
  }
}
