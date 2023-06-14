import Foundation

public struct SplitDouble {
  public var signum: Int
  public var wholeNumber: Int
  public var fraction: Double
}

public struct ValueFormatter {
  let formatter: NumberFormatter
  let roundingDenominator = 16

  public init() {
    let formatter = NumberFormatter()
    formatter.positiveInfinitySymbol = "result too large"
    formatter.negativeInfinitySymbol = "result too large"
    formatter.notANumberSymbol = "result can't be determined"
    self.formatter = formatter
  }

  fileprivate func split(_ aNumber: Double) -> SplitDouble {
    let (whole, fraction) = modf(aNumber)
    let sign = aNumber < 0 ? -1 : 1
    let wholeNumber = Int(whole)
    return SplitDouble(signum: sign, wholeNumber: wholeNumber, fraction: fraction)
  }

  fileprivate func formatWithFraction(_ aNumber: (Double)) -> String {
    if aNumber.isNaN || aNumber.isInfinite {
      return formatter.string(from: NSNumber(value: aNumber)) ?? "internal error"
    }

    let splitNumber = split(aNumber)
    let signum = splitNumber.signum
    let wholeNumber = splitNumber.wholeNumber
    let fraction = splitNumber.fraction

    var denominator = roundingDenominator
    var numerator = Int(round(abs(fraction) * Double(denominator)))

    if numerator.isMultiple(of: 2) {
      numerator /= 2
      denominator /= 2
    }

    if numerator == 0 {
      return "\(wholeNumber)"
    }
    if numerator == denominator {
      return "\(wholeNumber + signum)"
    }
    if wholeNumber == 0 {
      let signMarker = signum < 0 ? "-" : ""
      return "\(signMarker)\(numerator)/\(denominator)"
    }
    return "\(wholeNumber)·\(numerator)/\(denominator)"
  }

  public func format(_ imperialFormatter: ImperialFormatterFunction, _ value: Value) -> String {
    switch value {
    case .error(let message):
      return message

    case .number(let aNumber):
      let result = formatWithFraction(aNumber)
      return "\(result)"

    case .inches(let theInches):
      return imperialFormatter(formatter, theInches)
    }
  }
}
