import Foundation

public enum Value {
  case error
  case number(NSNumber)
}

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var value = Value.number(0)

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }

    switch value {
    case .error:
      return "error"

    case .number(let aNumber):
      return formatter.string(from: aNumber) ?? ""
    }
  }

  public func clear(_: String) {
    pending = ""
    alreadyEnteringNewNumber = false
    value = .number(0)
  }

  public func digit(_ digit: String) {
    if !alreadyEnteringNewNumber {
      pending = ""
      alreadyEnteringNewNumber = true
    }
    pending.append(digit)
  }

  fileprivate func encodePendingValue() {
    guard !pending.isEmpty else { return }

    let possibleNumber = formatter.number(from: pending)
    value = possibleNumber == nil ? Value.error : Value.number(possibleNumber!)
    pending = ""
  }

  public func enter(_: String) {
    encodePendingValue()

    alreadyEnteringNewNumber = false
  }
}
