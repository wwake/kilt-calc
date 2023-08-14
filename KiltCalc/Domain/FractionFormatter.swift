import Foundation

public struct FractionFormatter {
  static let fractionSeparator = "\u{2022}"
  static let skoshPlus = "⊕"
  static let skoshMinus = "⊖"

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
