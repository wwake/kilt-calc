import Foundation

public class Keypad: ObservableObject {
  let contents: [[Key]]

  public init(_ calculator: Calculator) {
    self.contents = [
      [
        Key("C"),
        Key("("),
        Key(")"),
        Key("%"),
        Key("\u{232B}")
      ],
      [
        Key("yd"),
        Key("ft"),
        Key("in"),
        Key("/"),
        Key("\u{00f7}")
      ],
      [
        Key("MC"),
        Key("7", Calculator.digit(calculator)),
        Key("8", Calculator.digit(calculator)),
        Key("9", Calculator.digit(calculator)),
        Key("\u{00d7}")
      ],
      [
        Key("MR"),
        Key("4", Calculator.digit(calculator)),
        Key("5", Calculator.digit(calculator)),
        Key("6", Calculator.digit(calculator)),
        Key("-")
      ],
      [
        Key("M-"),
        Key("1", Calculator.digit(calculator) ),
        Key("2", Calculator.digit(calculator)),
        Key("3", Calculator.digit(calculator)),
        Key("+")
      ],
      [
        Key("M+"),
        Key("0", Calculator.digit(calculator)),
        Key("\u{22c5}"),
        Key("\u{00b1}"),
        Key("=", Calculator.enter(calculator))
      ],
    ]
  }
}
