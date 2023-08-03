import Foundation

public class PleatEquations {
  private var locked = false

  private var hip: Double = 1
  private var fabric: Double = 1
  private(set) var count: Int = 1
  private(set) var width: Double = 1

  fileprivate func startPleat(_ newHip: Double, _ newFabric: Double, _ initialWidth: Double, _ action: () -> Void) {
    if locked { return}

    self.hip = newHip
    self.fabric = newFabric

    count = Int(round(hip / initialWidth))
    width = hip / Double(count)

    lockedAction(action)
  }

  func startBoxPleat(hip newHip: Double, fabric newFabric: Double, action: () -> Void) {
    let initialWidth = newFabric / 3.0
    startPleat(newHip, newFabric, initialWidth, action)
  }

  func startKnifePleat(hip newHip: Double, fabric newFabric: Double, action: () -> Void) {
    let initialWidth = 1.0
    startPleat(newHip, newFabric, initialWidth, action)
  }

  func setCount(_ newCount: Int, action: () -> Void) {
    if locked { return}

    count = newCount
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
