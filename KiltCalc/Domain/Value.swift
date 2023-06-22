import Foundation

public enum Value {
  case error(String)
  case number(Double)
  case inches(Double)

  static let formatter = NumberFormatter()
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

  fileprivate static func parseDouble(_ string: Substring) throws -> Double {
    let numberPart = formatter.number(from: String(string))?.doubleValue
    if numberPart == nil {
      throw ParseError.error("number too big or too small")
    }
    return numberPart!
  }

  fileprivate static func parseFraction(_ numeratorString: Substring, _ denominatorString: Substring) throws -> Double {
    let numerator = try parseDouble(numeratorString)
    let denominator = try parseDouble(denominatorString)

    return numerator / denominator
  }

  fileprivate static func parseNumber(_ string: String) throws -> Double {
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
      return try parseDouble(justNumberMatch.0)
      // swiftlint:disable:previous implicit_return
    }

    if let numAndDenom = string.wholeMatch(of: /(?<whole>[0-9]+)\/(?<denom>[0-9]+)/) {
      return try parseFraction(numAndDenom.whole, numAndDenom.denom)
      // swiftlint:disable:previous implicit_return
    }

    guard let numberMatch = string.wholeMatch(
      of: /(?<whole>[0-9]+)\.(?<num>[0-9]+)\/(?<denom>[0-9]+)/
    ) else {
      throw ParseError.error("missing denominator")
    }

    let wholeNumber = try parseDouble(numberMatch.whole)
    let fraction = try parseFraction(numberMatch.num, numberMatch.denom)

    return wholeNumber + fraction
  }

  static func parse(_ input: String) -> Value {
    do {
      let numberCharacters = /[0-9\/.]+/
      let unitCharacters = /[a-z ]+/

      let numbers = try input
        .split(separator: unitCharacters)
        .map { try Self.parseNumber(String($0)) }

      if numbers.isEmpty { return .error("no value found") }

      let units = input.split(separator: numberCharacters)
        .map { $0.trimmingCharacters(in: .whitespaces) }

      if numbers.count == 1 && units.count == 0 {
        return .number(numbers[0])
      }

      if numbers.count != units.count {
        return .error("numbers and units don't match")
      }

      var inches = 0.0
      zip(numbers, units).forEach { number, unit in
        inches += ImperialUnit.asInches(number, String(unit))
      }

      return Value.inches(inches)
    } catch ParseError.error(let errorString) {
      return .error(errorString)
    } catch {
      return .error("internal error")
    }
  }
}
