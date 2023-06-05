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
        Key("C", .clear),
        Key("("),
        Key(")"),
        Key("%"),
        Key("\u{232B}", .backspace),
      ],
      [
        Key("yd", .unit(.yard)),
        Key("ft", .unit(.foot)),
        Key("in", .unit(.inch)),
        Key("/"),
        Key("\u{00f7}", .divide),
      ],
      [
        Key("MC"),
        Key("7", .digit(7)),
        Key("8", .digit(8)),
        Key("9", .digit(9)),
        Key("\u{00d7}", .multiply),
      ],
      [
        Key("MR"),
        Key("4", .digit(4)),
        Key("5", .digit(5)),
        Key("6", .digit(6)),
        Key("-", .subtract),
      ],
      [
        Key("M-"),
        Key("1", .digit(1)),
        Key("2", .digit(2)),
        Key("3", .digit(3)),
        Key("+", .add),
      ],
      [
        Key("M+"),
        Key("0", .digit(0)),
        Key("\u{22c5}"),
        Key("\u{00b1}"),
        Key("=", .equals),
      ],
    ]
  }
}
