public enum Entry {
  case tbd
  case clear
  case backspace
  case equals
  case unit(ImperialUnit)
  case binary(Operator)
  case unary(Operator)
  case digit(Int)
  case leftParend
  case rightParend
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
    if case .unit = self { return true }
    return false
  }
}

extension Entry: CustomStringConvertible {
  public var description: String {
    switch self {
    case .tbd:
      return "TBD"

    case .clear, .backspace, .equals:
      return ""

    case .unit(let unit):
      return " \(unit.description) "

    case .binary(let theOperator), .unary(let theOperator):
      return theOperator.name

    case .digit(let digit):
      return "\(digit)"

    case .leftParend:
      return "("

    case .rightParend:
      return ")"

    case .ending:
      return "$"
    }
  }
}