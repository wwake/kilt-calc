@testable import InchCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_error() {
    XCTAssertEqual(Value.error.description(ImperialFormatter.asInches), "error")
  }

  func test_numberWithoutUnits() {
    XCTAssertEqual(Value.number(42).description(ImperialFormatter.asInches), "42")
  }

  func test_zeroInches() throws {
    XCTAssertEqual(Value.unit(0).description(ImperialFormatter.asInches), "0 in")
  }

  func test_ValueWithYardFeetInchFormatter() throws {
    XCTAssertEqual(Value.unit(63).description(ImperialFormatter.asYardFeetInches), "1 yd 2 ft 3 in")
  }
}
