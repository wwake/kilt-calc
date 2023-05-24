import Foundation

public enum Value {
  case number(NSNumber)
}

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var value = Value.number(0)

  public var display: String {
    if !pending.isEmpty { return pending }

    if case let .number(aNumber) = value {
      let formatter = NumberFormatter()
      return formatter.string(from: aNumber) ?? ""
    }

    return "??" // can't happen
  }

  public func clear(_: String) {
    pending = ""
    alreadyEnteringNewNumber = false
  }

  public func digit(_ digit: String) {
    if !alreadyEnteringNewNumber {
      pending = ""
      alreadyEnteringNewNumber = true
    }
    pending.append(digit)
  }

  public func enter(_: String) {
    let formatter = NumberFormatter()
    value = Value.number(formatter.number(from: pending)!)
    pending = ""
    alreadyEnteringNewNumber = false
  }
}
