import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var operands = Stack([Value.number(0)])

  @Published private(set) var operators: [String] = Stack([])

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }
    return operands.top.format(ImperialFormatter.asYardFeetInches)
  }

  public func clear(_: String) {
    pending = ""
    alreadyEnteringNewNumber = false
    operands = Stack([.number(0)])
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
    operands.push(Value.parse(pending))
    pending = ""
  }

  public func enter(_: String) {
    encodePendingValue()
    alreadyEnteringNewNumber = false

    while !operators.isEmpty {
      let top = operators.pop()
      let b = operands.pop()
      let a = operands.pop()

      switch top {
      case "+":
        operands.push(a.plus(b))

      case "-":
        operands.push(a.minus(b))

      default:
        break
      }
    }
  }

  public func unit(_ value: String) {
    pending.append(value)
  }

  public func op(_ op: String) {
    encodePendingValue()
    operators.push(op)
  }
}
