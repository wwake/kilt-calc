@testable import InchCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_zero() throws {
    XCTAssertEqual(Value.unit(0).description(ImperialFormatter.asInches), "0 in")
  }

  func test_ValueWithYardFeetInchFormatter() throws {
    XCTAssertEqual(Value.unit(63).description(ImperialFormatter.asYardFeetInches), "1 yd 2 ft 3 in")
  }

  // Test Value's asString - error, number, mixed units
}
