@testable import InchCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_zero() throws {
    XCTAssertEqual(Value.unit(0, 0, 0).asString, "0 in")
  }

  // Test Value's asString - error, number, mixed units
}
