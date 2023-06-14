import Foundation

public struct ValueFormatter {
  let formatter: NumberFormatter
  let roundingDenominator = 8

  public init() {
    let formatter = NumberFormatter()
    formatter.positiveInfinitySymbol = "result too large"
    formatter.negativeInfinitySymbol = "result too large"
    formatter.notANumberSymbol = "result can't be determined"
    self.formatter = formatter
  }

  fileprivate func formatWithFraction(_ aNumber: (Double)) -> String {
    let nonFractionString = formatter.string(from: NSNumber(value: aNumber)) ?? "internal error"
    if nonFractionString.wholeMatch(of: /.*[A-Za-z]$/) != nil { return nonFractionString }

    let (whole, fraction) = modf(aNumber)
    let wholeNumber = Int(whole)

    let numerator = Int(round(fraction * Double(roundingDenominator)))

    if numerator == 0 || numerator == roundingDenominator {
      return nonFractionString
    }
    if wholeNumber == 0 {
      return "\(numerator)/\(roundingDenominator)"
    }
    return "\(wholeNumber)·\(numerator)/\(roundingDenominator)"
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
