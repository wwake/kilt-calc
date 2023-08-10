import EGTest
@testable import KiltCalc
import XCTest

final class ValueFormatterTests: XCTestCase {
  private let formatter = ValueFormatter()

  func test_error() {
    XCTAssertEqual(
      formatter.format(ImperialFormatter.asInches, .error("error message")),
      "error message"
    )
  }

  func test_numberWithoutUnits() {
    XCTAssertEqual(
      formatter.format(ImperialFormatter.asInches, Value.number(42)),
      "42"
    )
  }

  func test_zeroInches() throws {
    XCTAssertEqual(
      formatter.format(ImperialFormatter.asInches, Value.inches(0)),
      "0 in"
    )
  }

  func test_ValueWithYardFeetInchFormatter() throws {
    XCTAssertEqual(
      formatter.format(ImperialFormatter.asYardFeetInches, Value.inches(63)),
      "1 yd 2 ft 3 in"
    )
  }

  func test_ExceptionalNumbers() {
    check([
      EG(Value.number(9.0 / 0), expect: "result too large"),
      EG(Value.inches(9.0 / 0), expect: "result too large"),

      EG(Value.number(-9.0 / 0), expect: "result too large"),
      EG(Value.inches(-9.0 / 0), expect: "result too large"),

      EG(Value.number(0.0 / 0), expect: "result can't be determined"),
      EG(Value.inches(0.0 / 0), expect: "result can't be determined"),
    ]) {
      EGAssertEqual(formatter.format(ImperialFormatter.asInches, $0.input), $0)
    }
  }

  func test_skoshSize() {
    let x64th = 0.015625
    let jot__ = 0.0000001

    check([
      EG(Value.number(0.75), expect: "6/8", "exact fraction"),
      EG(Value.number(0.75 + x64th - jot__), expect: "6/8", "not exact but too small for a skosh plus"),

      EG(Value.number(0.75 + x64th), expect: "6/8⊕", "just big enough for skosh plus"),
      EG(Value.number(0.75 + 2 * x64th - jot__), expect: "6/8⊕", "barely in range for skosh plus"),

      EG(Value.number(0.75 + 2 * x64th), expect: "13/16⊖", "just big enough for skosh minus"),
      EG(Value.number(0.75 + 3 * x64th - jot__), expect: "13/16⊖", "just small enough for skosh minus"),

      EG(Value.number(0.75 + 3 * x64th + jot__), expect: "13/16", "not exact but too big for a skosh minus"),
    ]) {
      EGAssertEqual(formatter.format(ImperialFormatter.asInches, $0.input), $0)
    }
  }
}
