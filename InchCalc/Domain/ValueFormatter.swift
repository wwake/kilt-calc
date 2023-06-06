import Foundation

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
      let result = formatter.string(from: NSNumber(value: aNumber)) ?? "internal error"
      return "\(result)"

    case .inches(let theInches):
      return imperialFormatter(formatter, theInches)
    }
  }
}
