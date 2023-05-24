import Foundation

public enum Value {
  case error
  case number(NSNumber)
  case unit(NSNumber, NSNumber, NSNumber)

  public var asString: String {
    let formatter = NumberFormatter()

    switch self {
    case .error:
      return "error"

    case .number(let aNumber):
      return formatter.string(from: aNumber) ?? ""

    case let .unit(theYards, theFeet, theInches):
      let yards = formatter.string(from: theYards) ?? ""
      let feet = formatter.string(from: theFeet) ?? ""
      let inches = formatter.string(from: theInches) ?? ""
      return "\(inches) in"
    }
  }
}
