import Foundation

public typealias ImperialFormatterFunction = (NSNumber) -> String

public enum ImperialFormatter {
  static let formatter = NumberFormatter()

  static func asInches(_ theInches: NSNumber) -> String {
    let inches = formatter.string(from: theInches) ?? ""
    return "\(inches) in"
  }
}
