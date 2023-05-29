import Foundation

public enum Value {
  case error(String)
  case number(NSNumber)
  case inches(NSNumber)
}

extension Value {
  public func plus(_ other: Value) -> Value {
    switch self {
    case .error:
      return self

    case .number(let a):
      switch other {
      case .error:
        return other

      case .number(let b):
        return .number(NSNumber(value: a.doubleValue + b.doubleValue))

      case .inches:
        return .error("error - mixing inches and numbers")
      }

    case .inches(let value):
        return .error("tbd")
    }
  }
}

extension Value {
  public func format(_ imperialFormatter: ImperialFormatterFunction) -> String {
    let formatter = NumberFormatter()

    switch self {
    case .error(let message):
      return message

    case .number(let aNumber):
      return formatter.string(from: aNumber) ?? ""

    case let .inches(theInches):
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

    if numbers.contains(nil) { return .error("number too big or too small") }

    if numbers.isEmpty { return .error("no value found") }

    if numbers.count > 1 && numbers.count != units.count {
      return .error("numbers and units don't match")
    }

    if numbers.count == 1 && units.count == 0 {
      return .number(numbers[0]!)
    }

    var inches = 0.0
    zip(numbers, units).forEach { number, unit in
      inches += ImperialUnits.asInches(number!.doubleValue, String(unit))
    }
    return Value.inches(NSNumber(value: inches))
  }
}
