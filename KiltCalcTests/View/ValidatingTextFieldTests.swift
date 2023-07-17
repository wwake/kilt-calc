@testable import KiltCalc
import XCTest

@MainActor
final class ValidatingTextFieldTests: XCTestCase {
  func test_successfulParseReturnsValueAndEmptyMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue(label: "Label", input: "3.5")
    XCTAssertEqual(value, Value.number(3.5))
    XCTAssertEqual(message, "")
  }

  func test_failedParseReturnsNilAndMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue(label: "Some Label", input: "3.5.")
    XCTAssertEqual(value, nil)
    XCTAssertEqual(message, "too many '.'")
  }

  func test_EmptyFieldGetsMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue(label: "My Label", input: "")
    XCTAssertEqual(value, nil)
    XCTAssertEqual(message, "My Label is missing")
  }
}
