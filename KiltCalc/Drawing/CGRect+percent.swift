import Foundation

extension CGRect {
  func xPercent(_ percentRatio: CGFloat) -> CGFloat {
    self.minX + percentRatio * (self.maxX - self.minX)
  }
}
