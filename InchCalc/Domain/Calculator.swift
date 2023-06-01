import Foundation

extension Stack<String> {
  public func joined() -> String {
    elements.joined()
  }
}

public class Expression {
  public func evaluate(_ input: Stack<String>) -> Value {
    if input.isEmpty { return Value.number(0) }

    var operands: Stack<Value> = Stack()
    var operators: Stack<Operator> = Stack()

    var pending = ""

    input.elements.forEach { command in
      switch command {
      case "0"..."9", " yd ", " ft ", " in ":
        pending.append(command)

      case "+", "-", Keypad.multiply, Keypad.divide:
        operands.push(Value.parse(pending))
        pending = ""

        let theOperator = Operator.make(command)
        while !operators.isEmpty && operators.top.precedence >= theOperator.precedence {
          let top = operators.pop()
          let b = operands.pop()
          let a = operands.pop()

          operands.push(top.evaluate(a, b))
        }

        operators.push(theOperator)

      default:
        break
      }
    }

    operands.push(Value.parse(pending))

    while !operators.isEmpty && operators.top.precedence >= 0 {
      let top = operators.pop()
      let b = operands.pop()
      let a = operands.pop()

      operands.push(top.evaluate(a, b))
    }

    return operands.pop()
  }
}

public class Calculator: ObservableObject {
  @Published private(set) var result = Value.number(0)
  @Published private(set) var input = Stack<String>()

  let formatter = NumberFormatter()

  public var display: String {
    if !input.isEmpty {
      return input.joined().trimmingCharacters(in: .whitespaces)
    }
    return result.format(ImperialFormatter.asYardFeetInches)
  }

  public func clear(_: String) {
    result = .number(0)
    input.clear()
  }

  public func digit(_ digit: String) {
    input.push(digit)
  }

  public func unit(_ value: String) {
    if !input.isEmpty && input.top.hasSuffix(" ") {
      _ = input.pop()
    }

    input.push(" \(value) ")
  }

  private func isOperator(_ string: String) -> Bool {
    ["+", "-", Keypad.multiply, Keypad.divide].contains(string)
  }

  public func op(_ op: String) {
    if !input.isEmpty {
      let lastChar = input.top
      if ["+", "-", Keypad.multiply, Keypad.divide].contains(lastChar) {
        _ = input.pop()
      }
    }

    input.push(op)
  }

  public func enter(_: String) {
    if !input.isEmpty && isOperator(input.top) {
      result = .error("expression can't end with an operator")
    } else {
      result = Expression().evaluate(input)
    }
    input.clear()
  }
}
