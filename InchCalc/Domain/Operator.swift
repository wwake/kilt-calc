public struct Operator {
  var name: String
  var precedence: Int
  var evaluate: (Value, Value) -> Value

  public static func make(_ name: String) -> Operator {
    switch name {
    case "+":
      return Operator(name: name, precedence: 3, evaluate: { a, b in a.plus(b) })

    case "-":
      return Operator(name: name, precedence: 3, evaluate: { a, b in a.minus(b) })

    default:
      return Operator(name: "?", precedence: 0, evaluate: { a, _ in a })
    }
  }
}
