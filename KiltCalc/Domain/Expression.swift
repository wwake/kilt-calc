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

  private func nextEntry() -> Entry {
    if index < input.count {
      index += 1
    }
    return input[index]
  }

  public func evaluate() -> Value {
    if input.isEmpty { return Value.number(0) }

    input.add(.ending)

    index = -1
    var entry = nextEntry()

  outer: while index < input.count {
      switch entry {
      case .digit, .unit:
        var pending = ""
        while entry.isOperand() {
          pending.append(entry.description)
          entry = nextEntry()
        }
        operands.push(Value.parse(pending))

      case .unary(let theOperator):
        if operands.isEmpty {
          operands.push(.error("no value found"))
        }
        evaluateUnary(theOperator)

        entry = nextEntry()

      case .binary(let theOperator):
        evaluateAtLeast(theOperator.precedence)
        operators.push(theOperator)
        entry = nextEntry()

      case .leftParend:
        operators.push(Operator(name: "(", precedence: 0, evaluate: { a, _ in a }))
        entry = nextEntry()

      case .rightParend:
        evaluateAtLeast(1)

        if operators.isEmpty {
          operands.clear()
          operands.push(.error("error - unbalanced parentheses"))
        } else {
          _ = operators.pop()
        }
        entry = nextEntry()

      case .ending:
        break outer

      default:
        entry = nextEntry()
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
