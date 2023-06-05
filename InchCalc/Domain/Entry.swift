public enum Entry {
  case clear
  case backspace
  case equals
  case unit(ImperialUnits)
  case add
  case subtract
  case multiply
  case divide
  case digit(Int)

  public func asUnit() -> ImperialUnits {
    if case let .unit(value) = self {
      return value
    }
    return .unspecified
  }

  public func asDigit() -> String {
    if case let .digit(value) = self {
      return "\(value)"
    }
    return "X"
  }

  public func op() -> Operator {
    switch self {
    case .add:
      return Operator.make("+")

    case .subtract:
      return Operator.make("-")

    case .multiply:
      return Operator.make(Keypad.multiply)

    case .divide:
      return Operator.make(Keypad.divide)

    default:
      return Operator.make("?")
    }
  }
}
