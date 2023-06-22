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

enum ParseError: Error {
  case error(String)
}

extension Value {
  typealias NumberMatch = Regex<Regex<Substring>.RegexOutput>.Match

  fileprivate static func wholeOrDecimalNumber(_ justNumberMatch: NumberMatch) throws -> Double {
    let formatter = NumberFormatter()
    let numberPart = formatter.number(from: String(justNumberMatch.0))?.doubleValue
    if numberPart == nil {
      throw ParseError.error("number too big or too small")
    }
    return numberPart!
  }

  fileprivate static func parseNumber(_ string: String) throws -> (Double?, String) {
    let formatter = NumberFormatter()

    if string.starts(with: /\//) {
      throw ParseError.error("can't start with '/'")
    }

    let numberOfSlashes = string.filter { $0 == "/" }.count
    if numberOfSlashes > 1 {
      throw ParseError.error("simple fractions only (at most one '/'")
    }

    let numberOfDots = string.filter { $0 == "." }.count
    if numberOfDots > 1 {
      throw ParseError.error("too many '.'")
    }

    if let justNumberMatch = string.wholeMatch(of: /[0-9]+\.?[0-9]*/) {
      return try (wholeOrDecimalNumber(justNumberMatch), "") // swiftlint:disable:this implicit_return
    }

    if let wholePlusFraction = string.wholeMatch(of: /(?<whole>[0-9]+)\/(?<denom>[0-9]+)/) {
      let numeratorString = String(wholePlusFraction.whole)
      let denominatorString = String(wholePlusFraction.denom)

      guard var numerator = formatter.number(from: numeratorString)?.doubleValue else {
        throw ParseError.error("number too big or too small")
      }

      let denominator = formatter.number(from: denominatorString)?.doubleValue
      if denominator == nil {
        throw ParseError.error("number too big or too small")
      }

      let result = numerator / denominator!

      return (result, "")
    }

    guard let numberMatch = string.wholeMatch(
      of: /(?<whole>[0-9]+)\.(?<num>[0-9]+)\/(?<denom>[0-9]+)/
    ) else {
      throw ParseError.error("missing denominator")
    }

    guard var wholeNumber = formatter.number(from: String(numberMatch.whole))?.doubleValue else {
      throw ParseError.error("number too big or too small")
    }

    guard let numerator = formatter.number(from: String(numberMatch.num))?.doubleValue else {
      throw ParseError.error("number too big or too small")
    }

    guard let denominator = formatter.number(from: String(numberMatch.denom))?.doubleValue else {
      throw ParseError.error("number too big or too small")
    }

    let result = wholeNumber + numerator / denominator

    return (result, "")
  }

  static func parse(_ input: String) -> Value {
    let numberCharacters = /[0-9\/.]+/
    let unitCharacters = /[a-z ]+/

    var numbers: [Double?] = []

    do {
      let potentialNumbers = try input
        .split(separator: unitCharacters)
        .map { try Self.parseNumber(String($0)) }

      if potentialNumbers.isEmpty { return .error("no value found") }

      let firstError = potentialNumbers
        .first(where: { $0.0 == nil })
      if firstError != nil {
        return .error(firstError!.1)
      }
      numbers = potentialNumbers.map { $0.0 }
    } catch ParseError.error(let errorString) {
      return .error(errorString)
    } catch {
    }

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
