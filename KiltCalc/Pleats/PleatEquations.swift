import Foundation

public class PleatEquations {
  private var hip: Double = 1
  private var fabric: Double = 1
  private(set) var count: Double = 1
  private(set) var width: Double = 1

  func setRequired(hip newHip: Double, fabric newFabric: Double) {
    hip = newHip
    fabric = newFabric

    let tentativePleatWidth = fabric / 3.0
    count = round(hip / tentativePleatWidth)
    width = hip / count
  }

  func setCount(_ newCount: Double) {
    count = round(newCount)
    width = min(fabric, hip / count)
  }

  func setWidth(_ newWidth: Double) {
    width = newWidth
    count = round(hip / width)
  }
}
