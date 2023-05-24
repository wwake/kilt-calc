import Foundation

public enum Value {
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
    case .number(let aNumber):
      return formatter.string(from: aNumber) ?? ""
    }
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
    value = Value.number(formatter.number(from: pending)!)
    pending = ""
    alreadyEnteringNewNumber = false
  }
}
