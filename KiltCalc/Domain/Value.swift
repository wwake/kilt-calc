import Foundation

public enum Value {
  case error(String)
  case number(Double)
  case inches(Double)
}

extension Value {
  static func + (lhs: Value, rhs: Value) -> Value {
    lhs.plus(rhs)
  }

  static func - (lhs: Value, rhs: Value) -> Value {
    lhs.minus(rhs)
  }

  static func * (lhs: Value, rhs: Value) -> Value {
    lhs.times(rhs)
  }

  static func / (lhs: Value, rhs: Value) -> Value {
    lhs.divide(rhs)
  }
}

extension Value: Equatable {
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
  typealias NumberMatch = Regex<Regex<Substring>.RegexOutput>.Match

  fileprivate static func wholeOrDecimalNumber(_ justNumberMatch: NumberMatch) -> (Double?, String) {
    let formatter = NumberFormatter()
    let numberPart = formatter.number(from: String(justNumberMatch.0))?.doubleValue
    if numberPart == nil {
      return (nil, "number too big or too small")
    }
    return (numberPart, "")
  }

  fileprivate static func parseNumber(_ string: String) -> (Double?, String) {
    if string.starts(with: /\//) {
      return (nil, "can't start with '/'")
    }

    let numberOfSlashes = string.filter { $0 == "/" }.count
    if numberOfSlashes >= 3 {
      return (nil, "too many '/' (at most 2)")
    }

    let numberOfDots = string.filter { $0 == "." }.count
    if numberOfDots > 1 {
      return (nil, "too many '.'")
    }

    if let justNumberMatch = string.wholeMatch(of: /[0-9]+\.?[0-9]*/) {
      return wholeOrDecimalNumber(justNumberMatch)
    }

    guard let numberMatch = string.wholeMatch(of:
/(?<wholeNumber>[0-9]+)(|\.(?<numerator>[0-9]+))(?<slashes>\/+)(?<denominator>[0-9]*)/
    ) else {
      return (nil, "use \u{00f7} for complicated fractions")
    }

    let formatter = NumberFormatter()

    let wholeNumberString = String(numberMatch.wholeNumber)
    var numeratorString = String(numberMatch.numerator ?? "")
    let slashes = String(numberMatch.slashes)
    let denominatorString = String(numberMatch.denominator)

    guard var wholeNumber = formatter.number(from: wholeNumberString)?.doubleValue else {
      return (nil, "number too big or too small")
    }

    if numeratorString.isEmpty {
      wholeNumber = 0
      numeratorString = wholeNumberString
    }

    guard let numerator = formatter.number(from: numeratorString)?.doubleValue else {
      return (nil, "number too big or too small")
    }

    var divisor = 1.0

    if !slashes.isEmpty {
      if slashes == "/" {
        divisor = 8.0

        if !denominatorString.isEmpty {
          let fractionPart = formatter.number(from: denominatorString)?.doubleValue
          if fractionPart == nil {
            return (nil, "number too big or too small")
          }
          divisor = fractionPart!
        }
      } else if slashes == "//" {
        divisor = 16.0

        if !denominatorString.isEmpty {
          return (nil, "at most one '/' between digits")
        }
      } else {
        return (nil, "Too many '/' (at most 2)")
      }
    }

    let result = wholeNumber + numerator / divisor

    return (result, "")
  }

  static func parse(_ input: String) -> Value {
    let numberCharacters = /[0-9\/.]+/
    let unitCharacters = /[a-z ]+/
    let potentialNumbers = input
      .split(separator: unitCharacters)
      .map { Self.parseNumber(String($0)) }

    if potentialNumbers.isEmpty { return .error("no value found") }

    let firstError = potentialNumbers
      .first(where: { $0.0 == nil })
    if firstError != nil {
      return .error(firstError!.1)
    }

    let numbers = potentialNumbers.map { $0.0 }

    let units = input.split(separator: numberCharacters)
      .map { $0.trimmingCharacters(in: .whitespaces) }

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
