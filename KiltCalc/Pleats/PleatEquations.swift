import Foundation

public class PleatEquations {
  private var locked = false

  private var hip: Double = 1
  private var fabric: Double = 1
  private(set) var count: Int = 1
  private(set) var width: Double = 1

  func setRequired(hip newHip: Double, fabric newFabric: Double, action: () -> Void) {
    if locked { return}

    hip = newHip
    fabric = newFabric

    let tentativePleatWidth = fabric / 3.0
    count = Int(round(hip / tentativePleatWidth))
    width = hip / Double(count)

    lockedAction(action)
  }

  func setCount(_ newCount: Double, action: () -> Void) {
    if locked { return}

    count = Int(round(newCount))
    width = min(fabric, hip / Double(count))

    lockedAction(action)
  }

  func setWidth(_ newWidth: Double, action: () -> Void) {
    if locked { return}

    width = newWidth
    count = Int(round(hip / width))

    lockedAction(action)
  }

  func lockedAction(_ action: () -> Void) {
    locked = true
    action()
    locked = false
  }
}
