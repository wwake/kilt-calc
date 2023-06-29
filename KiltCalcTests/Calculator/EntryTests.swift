@testable import KiltCalc
import XCTest

final class EntryTests: XCTestCase {
  func test_isOperand() throws {
    XCTAssertTrue(Entry.digit(7).isOperand())
    XCTAssertTrue(Entry.dot.isOperand())
    XCTAssertTrue(Entry.unit(.inch).isOperand())
    XCTAssertTrue(Entry.slash.isOperand())
    XCTAssertFalse(Entry.leftParend.isOperand())
  }
}
