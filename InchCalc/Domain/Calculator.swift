import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var operands = [Value.number(0)]

  @Published private(set) var operators: [String] = []

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }
    return operands.last!.format(ImperialFormatter.asYardFeetInches)
  }

  public func clear(_: String) {
    pending = ""
    alreadyEnteringNewNumber = false
    operands = [.number(0)]
  }

  public func digit(_ digit: String) {
    if !alreadyEnteringNewNumber {
      pending = ""
      alreadyEnteringNewNumber = true
    }
    pending.append(digit)
  }

  fileprivate func encodePendingValue() {
    if pending.isEmpty { return }
    operands.append(Value.parse(pending))
    pending = ""
  }

  public func enter(_: String) {
    encodePendingValue()
    alreadyEnteringNewNumber = false

    while !operators.isEmpty {
      let top = operators.removeLast()
      let b = operands.removeLast()
      let a = operands.removeLast()
      operands.append(a.plus(b))
    }
  }

  public func unit(_ value: String) {
    pending.append(value)
  }

  public func op(_ op: String) {
    encodePendingValue()
    operators.append(op)
  }
}
