public struct Operator {
  var name: String
  var precedence: Int
  var evaluate: (Value, Value) -> Value
}
