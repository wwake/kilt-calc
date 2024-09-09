@testable import KiltCalc
import XCTest

final class ValidatingTextFieldTests: XCTestCase {
  func test_successfulParseThatPassesValidation_ReturnsValueAndEmptyMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue(label: "Label", input: "3.5", validator: { _ in "" })
    XCTAssertEqual(value, Value.number(3.5))
    XCTAssertEqual(message, "")
  }

  func test_successfulParseButFailsValidation_ReturnsValueAndMessage() {
    let (value, message) = ValidatingTextField.updateBoundValue(
      label: "My Label", input: "1.5", validator: { _ in "failed validation" }
    )
    XCTAssertEqual(value, .number(1.5))
    XCTAssertEqual(message, "failed validation")
  }

  func test_failedParseReturnsNilAndMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue(
      label: "Some Label", input: "3.5.", validator: { _ in "wrong message" }
    )
    XCTAssertEqual(value, nil)
    XCTAssertEqual(message, "too many '.'")
  }

  func test_EmptyFieldGetsMessage() throws {
    let (value, message) = ValidatingTextField.updateBoundValue(
      label: "My Label", input: "", validator: { _ in "wrong message" }
    )
    XCTAssertEqual(value, nil)
    XCTAssertEqual(message, "Value is required")
  }
}
