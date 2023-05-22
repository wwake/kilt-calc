import Foundation

public class Keypad: ObservableObject {
  let contents: [[Key]]

  public init(_ calculator: Calculator) {
    self.contents = [
      [Key("C"), Key("("), Key(")"), Key("%"), Key("\u{232B}")],
      [Key("yd"), Key("ft"), Key("in"), Key("/"), Key("\u{00f7}")],
      [Key("MC"), Key("7", Calculator.digit(calculator)), Key("8"), Key("9"), Key("\u{00d7}")],
      [Key("MR"), Key("4"), Key("5"), Key("6"), Key("-")],
      [Key("M-"), Key("1"), Key("2"), Key("3"), Key("+")],
      [Key("M+"), Key("0"), Key("\u{22c5}"), Key("\u{00b1}"), Key("=", Calculator.enter(calculator))],
    ]
  }
}
