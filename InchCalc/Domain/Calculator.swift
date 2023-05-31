import Foundation

public class Calculator: ObservableObject {
  public var alreadyEnteringNewNumber: Bool {
    !pending.isEmpty
  }

  @Published private(set) var pending: String = ""

  @Published private(set) var result = Value.number(0)

  @Published private(set) var operands: Stack<Value> = Stack()

  @Published private(set) var operators: Stack<Operator> = Stack()

  @Published private(set) var lastOperator: String = ""

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty {
      return pending.trimmingCharacters(in: .whitespaces)
    }
    if !operands.isEmpty {
      if lastOperator.isEmpty {
        return operands.top.format(ImperialFormatter.asYardFeetInches)
      } else {
        return "\(operands.top.format(ImperialFormatter.asYardFeetInches)) \(lastOperator)"
      }
    }
    return result.format(ImperialFormatter.asYardFeetInches)
  }

  public func clear(_: String) {
    pending = ""
    operands = Stack([.number(0)])
  }

  public func digit(_ digit: String) {
    pending.append(digit)
    lastOperator = ""
  }

  public func unit(_ value: String) {
    if pending.hasSuffix(" ") {
      pending = String(pending.dropLast(4))
    }
    pending.append(" \(value) ")
    lastOperator = ""
  }

  fileprivate func encodePendingValue() {
    if pending.isEmpty { return }
    operands.push(Value.parse(pending))
    pending = ""
  }

  private func evaluate(atLeast precedence: Int) {
    while !operators.isEmpty && operators.top.precedence >= precedence {
      let top = operators.pop()
      let b = operands.pop()
      let a = operands.pop()

      operands.push(top.evaluate(a, b))
    }
  }

  public func op(_ op: String) {
    encodePendingValue()
    lastOperator = op
    let theOperator = Operator.make(op)
    evaluate(atLeast: theOperator.precedence)
    operators.push(theOperator)
  }

  public func enter(_: String) {
    encodePendingValue()
    evaluate(atLeast: 0)
    if !operands.isEmpty {
      result = operands.pop()
    }
    lastOperator = ""
    assert(operands.isEmpty)
    assert(operators.isEmpty)
  }
}
