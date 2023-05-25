@testable import InchCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_zero() throws {
    XCTAssertEqual(Value.unit(0).description, "0 in")
  }

  // Test Value's asString - error, number, mixed units
}
