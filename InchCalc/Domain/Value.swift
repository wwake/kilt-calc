import Foundation

public enum Value {
  case error
  case number(NSNumber)
  case unit(NSNumber)
}

extension Value {
  public func description(_ imperialFormatter: ImperialFormatterFunction) -> String {
    let formatter = NumberFormatter()

    switch self {
    case .error:
      return "error"

    case .number(let aNumber):
      return formatter.string(from: aNumber) ?? ""

    case let .unit(theInches):
      return imperialFormatter(theInches)
    }
  }
}

extension Value {
  static func parse(_ input: String) -> Value {
    let formatter = NumberFormatter()

    let numbers = input
      .split(separator: Regex(/[a-z]+/))
      .map { formatter.number(from: String($0)) }

    let units = input.split(separator: Regex(/[0-9]+/))

    if numbers.contains(nil) {
      return .error
    }

    if numbers.isEmpty {
      return .error
    }

    if numbers.count > 1 && numbers.count != units.count {
      return .error
    }

    if numbers.count == 1 && units.count == 0 {
      return .number(numbers[0]!)
    } else {
      var inches = 0.0
      zip(numbers, units).forEach { number, unit in
        if unit == "yd" {
          let possibleNumber = number!
          inches += possibleNumber.doubleValue * ImperialFormatter.inchesPerYard
        }
        if unit == "ft" {
          let possibleNumber = number!
          inches += possibleNumber.doubleValue * ImperialFormatter.inchesPerFoot
        }
        if unit == "in" {
          let possibleNumber = number!
          inches += possibleNumber.doubleValue
        }
      }
      return Value.unit(NSNumber(value: inches))
    }
  }
}
