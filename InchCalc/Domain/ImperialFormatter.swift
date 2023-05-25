import Foundation

public typealias ImperialFormatterFunction = (NSNumber) -> String

public enum ImperialFormatter {
  static let inchesPerFoot = 12.0
  static let inchesPerYard = 36.0
  static let feetPerYard = 3.0

  static let formatter = NumberFormatter()

  static func asInches(_ theInches: NSNumber) -> String {
    let inches = formatter.string(from: theInches) ?? ""
    return "\(inches) in"
  }

  static func asFeetInches(_ theInches: NSNumber) -> String {
    let original = theInches.doubleValue

    if original < inchesPerFoot {
      return asInches(theInches)
    }

    let feet = floor(original / inchesPerFoot)
    let inches = original - feet * inchesPerFoot

    let feetString = formatter.string(from: NSNumber(value: feet)) ?? ""
    let inchString = formatter.string(from: NSNumber(value: inches)) ?? ""

    if inches == 0 { return "\(feetString) ft" }
    return "\(feetString) ft \(inchString) in"
  }

  static func asYardFeetInches(_ theInches: NSNumber) -> String {
    let original = theInches.doubleValue

    if original < inchesPerYard {
      return asFeetInches(theInches)
    }

    let yards = floor(original / inchesPerYard)
    let inchesRemaining = original - yards * inchesPerYard

    let yardString = formatter.string(from: NSNumber(value: yards)) ?? ""
    let feetInchString = asFeetInches(NSNumber(value: inchesRemaining))

    return inchesRemaining == 0 ? "\(yardString) yd" : "\(yardString) yd \(feetInchString)"
  }
}
