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
      XCTAssertEqual(formatter.format(ImperialFormatter.asInches, $0.input), $0.expect, file: $0.file, line: $0.line)
    }
  }
}
