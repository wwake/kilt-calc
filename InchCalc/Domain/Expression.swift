public class Expression {
  var input: InputBuffer
  var operands: Stack<Value> = Stack()
  var operators: Stack<Operator> = Stack()

  init(_ input: InputBuffer) {
    self.input = input
  }

  fileprivate func evaluateAtLeast(_ precedence: Int) {
    while !operators.isEmpty && operators.top.precedence >= precedence {
      let top = operators.pop()
      let b = operands.pop()
      let a = operands.pop()

      operands.push(top.evaluate(a, b))
    }
  }

  public func evaluate() -> Value {
    if input.isEmpty { return Value.number(0) }

    var pending = ""

    input.forEach { entry in
      switch entry {
      case .digit, .unit:
        pending.append(entry.description)

      case .binary(let theOperator):
        operands.push(Value.parse(pending))
        pending = ""

        evaluateAtLeast(theOperator.precedence)
        operators.push(theOperator)

      case .add(let theOperator), .subtract(let theOperator), .multiply(let theOperator), .divide(let theOperator):
        operands.push(Value.parse(pending))
        pending = ""

        evaluateAtLeast(theOperator.precedence)
        operators.push(theOperator)

      default:
        break
      }
    }

    operands.push(Value.parse(pending))

    evaluateAtLeast(0)

    return operands.pop()
  }
}
