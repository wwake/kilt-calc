import Foundation

extension Stack<String> {
  public func joined() -> String {
    elements.joined()
  }
}

public class Calculator: ObservableObject {
  public var alreadyEnteringNewNumber: Bool {
    !pending.isEmpty
  }

  @Published private(set) var pending: String = ""

  @Published private(set) var result = Value.number(0)

  @Published private(set) var operands: Stack<Value> = Stack()

  @Published private(set) var operators: Stack<Operator> = Stack()

  @Published private(set) var lastOperator: String = ""

  @Published private(set) var input = Stack<String>()

  let formatter = NumberFormatter()

  public var display: String {
    if !input.isEmpty {
      return input.joined().trimmingCharacters(in: .whitespaces)
    }
    return result.format(ImperialFormatter.asYardFeetInches)
  }

  public func clear(_: String) {
    pending = ""
    operands = Stack([.number(0)])
    lastOperator = ""
    result = .number(0)
    input.clear()
  }

  public func digit(_ digit: String) {
    handleOperator(lastOperator)
    pending.append(digit)
    input.push(digit)
  }

  public func unit(_ value: String) {
    handleOperator(lastOperator)

    if pending.hasSuffix(" ") {
      pending = String(pending.dropLast(4))
    }
    if !input.isEmpty && input.top.hasSuffix(" ") {
      _ = input.pop()
    }

    pending.append(" \(value) ")
    input.push(" \(value) ")
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

  fileprivate func handleOperator(_ op: String) {
    if lastOperator.isEmpty { return }
    let theOperator = Operator.make(op)
    evaluate(atLeast: theOperator.precedence)
    operators.push(theOperator)
    lastOperator = ""
  }

  public func op(_ op: String) {
    encodePendingValue()
    lastOperator = op

    if !input.isEmpty {
      let lastChar = input.top
      if ["+", "-", Keypad.multiply, Keypad.divide].contains(lastChar) {
        _ = input.pop()
      }
    }

    input.push(op)
  }

//  private func evaluate2(_ input: Stack<String>) -> Value {
//    input.elements.forEach { command in
//      switch command {
//        case "0"..."9":
//      }
//    }
//    return Value.error("tbd")
//  }

  public func enter(_: String) {
    encodePendingValue()
  //  print(evaluate2(input))
    if !lastOperator.isEmpty {
      result = .error("expression can't end with an operator")
    } else {
      evaluate(atLeast: 0)
      if !operands.isEmpty {
        result = operands.pop()
      }
      assert(operands.isEmpty)
      assert(operators.isEmpty)
    }
    lastOperator = ""
    operands.clear()
    operators.clear()
    input.clear()
  }
}
