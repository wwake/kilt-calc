struct Keypad {
  let contents: [[Key]]

  static var example: Keypad {
    Keypad(contents: [
      [Key("C"), Key("("), Key(")"), Key("\u{232B}")],
      [Key("yd"), Key("ft"), Key("in"), Key("+")]
    ])
  }
}
