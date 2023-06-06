public struct Operator {
  var name: String
  var precedence: Int
  var evaluate: (Value, Value) -> Value

  public static func make(_ entry: Entry) -> Operator {
    switch entry {
    case .binary(let theOperator):
      return theOperator

    case .add:
      return Operator(name: "+", precedence: 3, evaluate: +)

    case .subtract:
      return Operator(name: "-", precedence: 3, evaluate: -)

    case .multiply:
      return Operator(name: "*", precedence: 5, evaluate: *)

    case .divide:
      return Operator(name: "/", precedence: 5, evaluate: /)

    default:
      return Operator(name: "?", precedence: 1, evaluate: { a, _ in a })
    }
  }
}
