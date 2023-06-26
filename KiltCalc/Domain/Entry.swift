public enum Entry {
  case clear
  case backspace
  case equals
  case unit(ImperialUnit)
  case binary(Operator)
  case unary(Operator)
  case digit(Int)
  case value(Value)
  case dot
  case slash
  case leftParend
  case rightParend

  case memoryClear
  case memoryRecall
  case memoryAdd
  case memorySubtract

  case pleat
  case ending

  public func asUnit() -> ImperialUnit {
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

  public func isBinaryOperator() -> Bool {
    if case .binary = self { return true}
    return false
  }

  public var isUnaryOperator: Bool {
    if case .unary = self { return true}
    return false
  }

  public func isUnit() -> Bool {
    if case .unit = self { return true }
    return false
  }

  public func isOperand() -> Bool {
    if case .digit = self { return true }
    if case .dot = self { return true }
    if case .unit = self { return true }
    if case .slash = self { return true }
    return false
  }
}

extension Entry: CustomStringConvertible {
  public var description: String {
    switch self {
    case .clear:
      return "CLEAR"

    case .backspace:
      return "BACKSPACE"

    case .equals:
      return "="

    case .unit(let unit):
      return " \(unit.description) "

    case .binary(let theOperator), .unary(let theOperator):
      return theOperator.name

    case .digit(let digit):
      return "\(digit)"

    case .value(let value):
      print("value not implemented")
      return "value"

    case .dot:
      return "."

    case .slash:
      return "/"

    case .leftParend:
      return "("

    case .rightParend:
      return ")"

    case .memoryClear:
      return "MC"

    case .memoryRecall:
      return "MR"

    case .memoryAdd:
      return "M+"

    case .memorySubtract:
      return "M-"

    case .pleat:
      return "Z"

    case .ending:
      return "$"
    }
  }
}
