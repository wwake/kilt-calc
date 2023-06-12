public class Expression {
  var input: InputBuffer
  var operands: Stack<Value> = Stack()
  var operators: Stack<Operator> = Stack()

  var index = 0

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

  fileprivate func evaluateUnary(_ unaryOp: Operator) {
    let a = operands.pop()
    operands.push(unaryOp.evaluate(a, .error("Unary op has no second argument")))
  }

  private func current() -> Entry {
    input[index]
  }

  private func nextEntry() {
    if index < input.count {
      index += 1
    }
  }

  public func evaluate() -> Value {
    if input.isEmpty { return Value.number(0) }

    input.add(.ending)

    index = 0
    var entry = current()

  outer: while index < input.count {
      switch entry {
      case .digit, .unit:
        var pending = ""
        while entry.isOperand() {
          pending.append(entry.description)
          nextEntry()
          entry = current()
        }
        operands.push(Value.parse(pending))

      case .unary(let theOperator):
        if operands.isEmpty {
          operands.push(.error("no value found"))
        } else {
          evaluateUnary(theOperator)
        }
        nextEntry()
        entry = current()

      case .binary(let theOperator):
        evaluateAtLeast(theOperator.precedence)
        operators.push(theOperator)
        nextEntry()
        entry = current()

      case .leftParend:
        operators.push(Operator(name: "(", precedence: 0, evaluate: { a, _ in a }))
        nextEntry()
        entry = current()

      case .rightParend:
        evaluateAtLeast(1)

        if operators.isEmpty {
          operands.clear()
          operands.push(.error("error - unbalanced parentheses"))
        } else {
          _ = operators.pop()
        }
        nextEntry()
        entry = current()

      case .ending:
        break outer

      default:
        nextEntry()
        entry = current()
      }
    }

    evaluateAtLeast(1)

    if operators.count != 0 {
      return .error("error - unbalanced parentheses")
    }

    if operands.count != 1 {
      return .error("error - unbalanced parentheses")
    }
    return operands.pop()
  }
}
