import Foundation

public struct SplitDouble {
  public var signum: Int
  public var wholeNumber: Int
  public var fraction: Double

  public var asDouble: Double {
    Double(signum) * (Double(wholeNumber) + fraction)
  }
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
    return SplitDouble(signum: sign, wholeNumber: abs(wholeNumber), fraction: abs(fraction))
  }

  fileprivate func findAdjustment(_ aNumber: Double, _ split: SplitDouble) -> String {
    let computed = split.asDouble
    if computed < aNumber {
      return "⊕"
    }
    if computed > aNumber {
      return "⊖"
    }
    return ""
  }

  fileprivate func formatWithFraction(_ aNumber: (Double)) -> String {
    if aNumber.isNaN || aNumber.isInfinite {
      return formatter.string(from: NSNumber(value: aNumber)) ?? "internal error"
    }

    let splitNumber = split(aNumber)
    let signum = splitNumber.signum
    var wholeNumber = splitNumber.wholeNumber
    let fraction = splitNumber.fraction

    var denominator = roundingDenominator
    var numerator = Int(round(fraction * Double(denominator)))

    if numerator.isMultiple(of: 2) {
      numerator /= 2
      denominator /= 2
    }

    if numerator == denominator {
      wholeNumber += 1
    }

    let adjustment = findAdjustment(
      aNumber,
      SplitDouble(signum: signum, wholeNumber: wholeNumber, fraction: Double(numerator) / Double(denominator))
    )

    let signMarker = signum < 0 ? "-" : ""

    var result = signMarker
    if numerator == 0 || numerator == denominator {
      result += "\(wholeNumber)"
    } else
    if wholeNumber == 0 {
      result += "\(numerator)/\(denominator)"
    } else {
      result += "\(wholeNumber)·\(numerator)/\(denominator)"
    }
    return result + adjustment
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
