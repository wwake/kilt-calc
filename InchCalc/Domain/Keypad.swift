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
}

public struct Keypad {
  static let backspace = "\u{232B}"
  static let divide = "\u{00f7}"
  static let multiply = "\u{00d7}"
  static let dot = "\u{22c5}"
  static let plusOrMinus = "\u{00b1}"

  let contents: [[Key]]

  public init(_ calculator: Calculator) {
    self.contents = [
      [
        Key("C", { _ in calculator.enter(.clear) }),
        Key("("),
        Key(")"),
        Key("%"),
        Key("\u{232B}", { _ in calculator.enter(.backspace) }),
      ],
      [
        Key("yd", { _ in calculator.enter(.unit(.yard)) }),
        Key("ft", { _ in calculator.enter(.unit(.foot)) }),
        Key("in", { _ in calculator.enter(.unit(.inch)) }),
        Key("/"),
        Key("\u{00f7}", { _ in calculator.enter(.divide) }),
      ],
      [
        Key("MC"),
        Key("7", { _ in calculator.enter(.digit(7)) }),
        Key("8", { _ in calculator.enter(.digit(8)) }),
        Key("9", { _ in calculator.enter(.digit(9)) }),
        Key("\u{00d7}", { _ in calculator.enter(.multiply) }),
      ],
      [
        Key("MR"),
        Key("4", { _ in calculator.enter(.digit(4)) }),
        Key("5", { _ in calculator.enter(.digit(5)) }),
        Key("6", { _ in calculator.enter(.digit(6)) }),
        Key("-", { _ in calculator.enter(.subtract) }),
      ],
      [
        Key("M-"),
        Key("1", { _ in calculator.enter(.digit(1)) }),
        Key("2", { _ in calculator.enter(.digit(2)) }),
        Key("3", { _ in calculator.enter(.digit(3)) }),
        Key("+", { _ in calculator.enter(.add) }),
      ],
      [
        Key("M+"),
        Key("0", { _ in calculator.enter(.digit(0)) }),
        Key("\u{22c5}"),
        Key("\u{00b1}"),
        Key("=", { _ in calculator.enter(.equals) }),
      ],
    ]
  }
}
