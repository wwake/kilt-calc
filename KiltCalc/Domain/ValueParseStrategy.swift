import Foundation

extension String: Error {
  var description: String {
    self
  }
}

public struct ValueParseStrategy: ParseStrategy {
  static let formatter = NumberFormatter()

  public func parse(_ value: String) throws -> Value {
    try Self.parse(value)
  }

  static func parse(_ rawInput: String) throws -> Value {
    var input = rawInput
    input.replace("•", with: ".")
    input.replace("⊕", with: "")
    input.replace("⊖", with: "")

    let numbers = try splitNumbers(input)
    let units = try splitUnits(input)

    if numbers.count == 1 && units.count == 0 {
      return .number(numbers[0])
    }

    if numbers.count != units.count {
      throw "Numbers and units don't match"
    }

    var inches = 0.0
    zip(numbers, units).forEach { number, unit in
      inches += ImperialUnit.asInches(number, String(unit))
    }

    return Value.inches(inches)
  }

  static func splitNumbers(_ input: String) throws -> [Double] {
    let unitCharacters = /[a-z ]+/

    let numbers = try input
      .split(separator: unitCharacters)
      .map { try Self.parseNumber(String($0)) }

    if numbers.isEmpty { throw "No value found" }

    return numbers
  }

  static func splitUnits(_ input: String) throws -> [String] {
    let numberCharacters = /[0-9\/.]+/
    return input.split(separator: numberCharacters)
      .map { $0.trimmingCharacters(in: .whitespaces) }
  }

  fileprivate static func parseNumber(_ string: String) throws -> Double {
    if string.starts(with: /\//) {
      throw "can't start with '/'"
    }

    let numberOfSlashes = string.filter { $0 == "/" }.count
    if numberOfSlashes > 1 {
      throw "simple fractions only (at most one '/'"
    }

    let numberOfDots = string.filter { $0 == "." }.count
    if numberOfDots > 1 {
      throw "too many '.'"
    }

    if let justNumberMatch = string.wholeMatch(of: /[0-9]+\.?[0-9]*/) {
      return try parseDouble(justNumberMatch.0)
    }

    if let numAndDenom = string.wholeMatch(of: /(?<whole>[0-9]+)\/(?<denom>[0-9]+)/) {
      return try parseFraction(numAndDenom.whole, numAndDenom.denom)
    }

    guard let numberMatch = string.wholeMatch(
      of: /(?<whole>[0-9]+)\.(?<num>[0-9]+)\/(?<denom>[0-9]+)/
    ) else {
      throw "missing denominator"
    }

    let wholeNumber = try parseDouble(numberMatch.whole)
    let fraction = try parseFraction(numberMatch.num, numberMatch.denom)

    return wholeNumber + fraction
  }

  fileprivate static func parseDouble(_ string: Substring) throws -> Double {
    let numberPart = formatter.number(from: String(string))?.doubleValue
    if numberPart == nil {
      throw "number too big or too small"
    }
    return numberPart!
  }

  fileprivate static func parseFraction(_ numeratorString: Substring, _ denominatorString: Substring) throws -> Double {
    let numerator = try parseDouble(numeratorString)
    let denominator = try parseDouble(denominatorString)

    return numerator / denominator
  }
}
