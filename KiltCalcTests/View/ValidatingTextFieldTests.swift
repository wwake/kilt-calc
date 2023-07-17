@testable import KiltCalc
import XCTest

@MainActor
final class ValidatingTextFieldTests: XCTestCase {
  func test_successfulParseReturnsValueAndEmptyMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue("3.5")
    XCTAssertEqual(value, Value.number(3.5))
    XCTAssertEqual(message, "")
  }

  func test_failedParseReturnsNilAndMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue("3.5.")
    XCTAssertEqual(value, nil)
    XCTAssertEqual(message, "too many '.'")
  }
}
