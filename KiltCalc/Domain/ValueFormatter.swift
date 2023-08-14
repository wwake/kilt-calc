import Foundation

public enum Skosh: String {
  case nothing = ""
  case plus = "⊕"
  case minus = "⊖"
}

public struct RoundedFraction {
  static let skoshCutoff = 1.0 / 64
  let roundingDenominator = 16

  public var original: Double

  public var signum: Int
  public var wholeNumber: Int
  public var numerator: Int = 0
  public var denominator: Int = 0

  private var originalFraction: Double

  public init(_ aNumber: Double) {
    original = aNumber

    let (wholePart, fractionPart) = modf(aNumber)

    signum = aNumber < 0 ? -1 : 1
    wholeNumber = abs(Int(wholePart))
    originalFraction = abs(fractionPart)

    (numerator, denominator) = self.fractionParts()

    if numerator == denominator {
      wholeNumber += 1
      numerator = 0
    }
  }

  public var skosh: Skosh {
    let rounded = self.asDouble

    if abs(rounded - original) < Self.skoshCutoff {
      return .nothing
    } else if original < rounded {
      return .minus
    } else {
      return .plus
    }
  }

  public var hasFraction: Bool {
    numerator != 0
  }

  private var asDouble: Double {
    Double(signum) * (Double(wholeNumber) + Double(numerator) / Double(denominator))
  }

  fileprivate func fractionParts() -> (Int, Int) {
    var denominator = roundingDenominator
    var numerator = Int(round(originalFraction * Double(denominator)))

    if numerator.isMultiple(of: 2) {
      numerator /= 2
      denominator /= 2
    }

    return (numerator, denominator)
  }
}

public struct FractionFormatter {
  static let fractionSeparator = "\u{2022}"
  static let skoshPlus = "⊕"
  static let skoshMinus = "⊖"
  static let skoshCutoff = 1.0 / 64

  let roundingDenominator = 16
  let formatter: NumberFormatter

  public init() {
    let formatter = NumberFormatter()
    formatter.positiveInfinitySymbol = "result too large"
    formatter.negativeInfinitySymbol = "result too large"
    formatter.notANumberSymbol = "result can't be determined"
    self.formatter = formatter
  }

  fileprivate func formatWholeAndFraction(_ value: RoundedFraction) -> String {
    var result = ""
    if value.wholeNumber != 0 || !value.hasFraction {
      result += "\(value.wholeNumber)"
    }

    if value.hasFraction {
      if value.wholeNumber != 0 {
        result += Self.fractionSeparator
      }
      result += "\(value.numerator)/\(value.denominator)"
    }
    return result
  }

  public func format(_ original: (Double)) -> String {
    if original.isNaN || original.isInfinite {
      return formatter.string(from: NSNumber(value: original)) ?? "internal error: ValueFormatter.format()"
    }

    let roundedFraction = RoundedFraction(original)

    let signMarker = roundedFraction.signum < 0 ? "-" : ""
    let formattedNumber = formatWholeAndFraction(roundedFraction)
    let skosh = roundedFraction.skosh.rawValue

    return signMarker + formattedNumber + skosh
  }
}

public struct ValueFormatter {
  let formatter: NumberFormatter

  public init() {
    let formatter = NumberFormatter()
    formatter.positiveInfinitySymbol = "result too large"
    formatter.negativeInfinitySymbol = "result too large"
    formatter.notANumberSymbol = "result can't be determined"
    self.formatter = formatter
  }

  public func format(_ imperialFormatter: ImperialFormatterFunction, _ value: Value) -> String {
    switch value {
    case .error(let message):
      return message

    case .number(let aNumber):
      let result = FractionFormatter().format(aNumber)
      return "\(result)"

    case .inches(let theInches):
      return imperialFormatter(FractionFormatter(), theInches)
    }
  }
}
