public enum Entry {
  case tbd
  case clear
  case backspace
  case equals
  case unit(ImperialUnit)
  case binary(Operator)
  case add(Operator)
  case subtract(Operator)
  case multiply(Operator)
  case divide(Operator)
  case unary(Operator)
  case digit(Int)

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
    switch self {
    case .binary, .add, .subtract, .multiply, .divide:
      return true

    default:
      return false
    }
  }

  public var isUnaryOperator: Bool {
    if case .unary = self { return true}
    return false
  }

//  public func precedenceValue() -> Int {
//    switch self {
//    case .add, .subtract:
//      return 3
//
//    case .multiply, .divide:
//      return 5
//
//    default:
//      return 1
//    }
//  }

  public func isUnit() -> Bool {
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

    case .add:
      return Keypad.add

    case .subtract:
      return Keypad.subtract

    case .multiply:
      return Keypad.multiply

    case .divide:
      return Keypad.divide

    case .digit(let digit):
      return "\(digit)"
    }
  }
}
