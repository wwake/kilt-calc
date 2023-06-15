import Foundation

public struct SplitDouble {
  public var signum: Int
  public var wholeNumber: Int
  public var fraction: Double

  public init(_ aNumber: Double) {
    let (wholePart, fractionPart) = modf(aNumber)

    signum = aNumber < 0 ? -1 : 1
    wholeNumber = abs(Int(wholePart))
    fraction = abs(fractionPart)
  }

  public init(signum: Int, wholeNumber: Int, numerator: Int, denominator: Int) {
    self.signum = signum
    self.wholeNumber = abs(wholeNumber)
    self.fraction = abs(Double(numerator) / Double(denominator))
  }

  public var asDouble: Double {
    Double(signum) * (Double(wholeNumber) + fraction)
  }

  fileprivate func fractionParts(_ roundingDenominator: Int) -> (Int, Int) {
    var denominator = roundingDenominator
    var numerator = Int(round(fraction * Double(denominator)))

    if numerator.isMultiple(of: 2) {
      numerator /= 2
      denominator /= 2
    }

    return (numerator, denominator)
  }
}

public struct FractionFormatter {
  let roundingDenominator = 16
  let formatter: NumberFormatter

  public init() {
    let formatter = NumberFormatter()
    formatter.positiveInfinitySymbol = "result too large"
    formatter.negativeInfinitySymbol = "result too large"
    formatter.notANumberSymbol = "result can't be determined"
    self.formatter = formatter
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

  fileprivate func formatWholeAndFraction(_ wholeNumber: Int, _ numerator: Int, _ denominator: Int) -> String {
    let hasFraction = numerator != 0 && numerator != denominator

    var result = ""
    if wholeNumber != 0 || !hasFraction {
      result += "\(wholeNumber)"
    }

    if hasFraction {
      if wholeNumber != 0 {
        result += "·"
      }
      result += "\(numerator)/\(denominator)"
    }
    return result
  }

  public func format(_ aNumber: (Double)) -> String {
    if aNumber.isNaN || aNumber.isInfinite {
      return formatter.string(from: NSNumber(value: aNumber)) ?? "internal error"
    }

    let splitNumber = SplitDouble(aNumber)
    let signum = splitNumber.signum
    var wholeNumber = splitNumber.wholeNumber

    let (numerator, denominator) = splitNumber.fractionParts(roundingDenominator)

    if numerator == denominator {
      wholeNumber += 1
    }

    let signMarker = signum < 0 ? "-" : ""

    let formattedNumber = formatWholeAndFraction(wholeNumber, numerator, denominator)

    let adjustment = findAdjustment(
      aNumber,
      SplitDouble(signum: signum, wholeNumber: wholeNumber, numerator: numerator, denominator: denominator)
    )

    return signMarker + formattedNumber + adjustment
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
