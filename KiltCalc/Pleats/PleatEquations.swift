import Foundation

public class PleatEquations {
  private var hip: Double = 1
  private var fabric: Double = 1
  private(set) var count: Double = 1
  private(set) var width: Double = 1

  func setRequired(hip: Double, fabric: Double) {
    self.hip = hip
    self.fabric = fabric

    let tentativePleatWidth = fabric / 3.0
    let countAsValue = hip / tentativePleatWidth
    count = round(countAsValue)
    width = hip / count
  }

  func setCount(_ count: Double) {
    self.count = round(count)

    let possiblePleatWidth = hip / self.count
    if possiblePleatWidth <= fabric {
      width = possiblePleatWidth
    } else {
      width = fabric
    }
  }
}
