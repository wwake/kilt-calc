public struct Operator {
  var precedence: Int
  var evaluate: (Value, Value) -> Value

  public static func make(_ entry: Entry) -> Operator {
    switch entry {
    case .add:
      return Operator(precedence: 3, evaluate: { a, b in a.plus(b) })

    case .subtract:
      return Operator(precedence: 3, evaluate: { a, b in a.minus(b) })

    case .multiply:
      return Operator(precedence: 5, evaluate: { a, b in a.times(b) })

    case .divide:
      return Operator(precedence: 5, evaluate: { a, b in a.divide(b) })

    default:
      return Operator(precedence: 1, evaluate: { a, _ in a })
    }
  }
}
