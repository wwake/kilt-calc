@testable import KiltCalc
import XCTest

final class EntryTests: XCTestCase {
  func test_isOperand() throws {
    XCTAssertTrue(Entry.digit(7).isOperand())
    XCTAssertTrue(Entry.dot.isOperand())
    XCTAssertTrue(Entry.unit(.inch).isOperand())
    XCTAssertTrue(Entry.slash.isOperand())
    XCTAssertTrue(Entry.value(Value.number(3.0), "3").isOperand())
    XCTAssertFalse(Entry.leftParend.isOperand())
  }
}
