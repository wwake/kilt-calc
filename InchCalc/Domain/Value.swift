import Foundation

public enum Value {
  case error(String)
  case number(NSNumber)
  case inches(NSNumber)
}

extension Value {
  public func negate() -> Value {
    switch self {
    case .error:
      return self

    case .number(let value):
      return .number(NSNumber(value: -value.doubleValue))

    case .inches(let value):
      return .inches(NSNumber(value: -value.doubleValue))
    }
  }

  public func minus(_ other: Value) -> Value {
    plus(other.negate())
  }

  public func plus(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
        return other

    case let (.number(a), .number(b)):
      return .number(NSNumber(value: a.doubleValue + b.doubleValue))

    case (.number, .inches),
          (.inches, .number):
        return .error("error - mixing inches and numbers")

    case let (.inches(a), .inches(b)):
        return .inches(NSNumber(value: a.doubleValue + b.doubleValue))
    }
  }

  public func times(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
      return other

    case let (.number(a), .number(b)):
      return .number(NSNumber(value: a.doubleValue * b.doubleValue))

    case let (.number(a), .inches(b)):
      return .inches(NSNumber(value: a.doubleValue * b.doubleValue))

    case let (.inches(a), .number(b)):
      return .inches(NSNumber(value: a.doubleValue * b.doubleValue))

    case (.inches, .inches):
      return .error("error - can't handle square inches")
    }
  }

  public func divide(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
      return other

    case let (.number(a), .number(b)):
      return .number(NSNumber(value: a.doubleValue / b.doubleValue))

    case (.number, .inches):
      return .error("error - can't divide number by inches")

    case let (.inches(a), .number(b)):
      return .inches(NSNumber(value: a.doubleValue / b.doubleValue))

    case let (.inches(a), .inches(b)):
      return .number(NSNumber(value: a.doubleValue / b.doubleValue))
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
      .split(separator: Regex(/[a-z ]+/))
      .map { formatter.number(from: String($0)) }

    let units = input.split(separator: Regex(/[0-9]+/))
      .map { $0.trimmingCharacters(in: .whitespaces) }

    if numbers.isEmpty { return .error("no value found") }

    if numbers.contains(nil) { return .error("number too big or too small") }

    if numbers.count == 1 && units.count == 0 {
      return .number(numbers[0]!)
    }

    if numbers.count != units.count {
      return .error("numbers and units don't match")
    }

    var inches = 0.0
    zip(numbers, units).forEach { number, unit in
      inches += ImperialUnits.asInches(number!.doubleValue, String(unit))
    }
    return Value.inches(NSNumber(value: inches))
  }
}
