import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var result = Value.number(0)

  @Published private(set) var operands: Stack<Value> = Stack()

  @Published private(set) var operators: Stack<Operator> = Stack()

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }
    if !operands.isEmpty {
      return operands.top.format(ImperialFormatter.asYardFeetInches)
    }
    return result.format(ImperialFormatter.asYardFeetInches)
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
    evaluate(atLeast: 0)
    if !operands.isEmpty {
      result = operands.pop()
    }
    assert(operands.isEmpty)
    assert(operators.isEmpty)
  }

  public func unit(_ value: String) {
    pending.append(" \(value) ")
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
    let theOperator = Operator.make(op)
    evaluate(atLeast: theOperator.precedence)
    operators.push(theOperator)
  }
}
