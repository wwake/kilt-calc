public enum Entry {
  case clear
  case backspace
  case equals
  case unit(ImperialUnits)
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
        Key("\u{00f7}", Calculator.op(calculator)),
      ],
      [
        Key("MC"),
        Key("7", Calculator.digit(calculator)),
        Key("8", Calculator.digit(calculator)),
        Key("9", Calculator.digit(calculator)),
        Key("\u{00d7}", Calculator.op(calculator)),
      ],
      [
        Key("MR"),
        Key("4", Calculator.digit(calculator)),
        Key("5", Calculator.digit(calculator)),
        Key("6", Calculator.digit(calculator)),
        Key("-", Calculator.op(calculator)),
      ],
      [
        Key("M-"),
        Key("1", Calculator.digit(calculator) ),
        Key("2", Calculator.digit(calculator)),
        Key("3", Calculator.digit(calculator)),
        Key("+", Calculator.op(calculator)),
      ],
      [
        Key("M+"),
        Key("0", Calculator.digit(calculator)),
        Key("\u{22c5}"),
        Key("\u{00b1}"),
        Key("=", { _ in calculator.enter(.equals) }),
      ],
    ]
  }
}
