@testable import InchCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_error() {
    XCTAssertEqual(Value.error.format(ImperialFormatter.asInches), "error")
  }

  func test_numberWithoutUnits() {
    XCTAssertEqual(Value.number(42).format(ImperialFormatter.asInches), "42")
  }

  func test_zeroInches() throws {
    XCTAssertEqual(Value.inches(0).format(ImperialFormatter.asInches), "0 in")
  }

  func test_ValueWithYardFeetInchFormatter() throws {
    XCTAssertEqual(Value.inches(63).format(ImperialFormatter.asYardFeetInches), "1 yd 2 ft 3 in")
  }
}
