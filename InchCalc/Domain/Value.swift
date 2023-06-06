import Foundation

public enum Value {
  case error(String)
  case number(Double)
  case inches(Double)
}

extension Value {
  public func negate() -> Value {
    switch self {
    case .error:
      return self

    case .number(let value):
      return .number(-value)

    case .inches(let value):
      return .inches(-value)
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
      return .number(a + b)

    case (.number, .inches),
          (.inches, .number):
        return .error("error - mixing inches and numbers")

    case let (.inches(a), .inches(b)):
        return .inches(a + b)
    }
  }

  public func times(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
      return other

    case let (.number(a), .number(b)):
      return .number(a * b)

    case let (.number(a), .inches(b)):
      return .inches(a * b)

    case let (.inches(a), .number(b)):
      return .inches(a * b)

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
      return .number(a / b)

    case (.number, .inches):
      return .error("error - can't divide number by inches")

    case let (.inches(a), .number(b)):
      return .inches(a / b)

    case let (.inches(a), .inches(b)):
      return .number(a / b)
    }
  }
}

extension Value {
  static func formatNumber(_ formatter: NumberFormatter, _ value: Double) -> String {
    if value.isInfinite {
      return "result too large"
    }
    let result = formatter.string(from: NSNumber(value: value)) ?? ""
    return "\(result)"
  }

  public func format(_ imperialFormatter: ImperialFormatterFunction) -> String {
    let formatter = NumberFormatter()

    switch self {
    case .error(let message):
      return message

    case .number(let aNumber):
      return Value.formatNumber(formatter, aNumber)

    case .inches(let theInches):
      return imperialFormatter(theInches)
    }
  }
}

extension Value {
  static func parse(_ input: String) -> Value {
    let formatter = NumberFormatter()

    let numbers = input
      .split(separator: Regex(/[a-z ]+/))
      .map { formatter.number(from: String($0))?.doubleValue }

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
      inches += ImperialUnit.asInches(number!, String(unit))
    }
    return Value.inches(inches)
  }
}
