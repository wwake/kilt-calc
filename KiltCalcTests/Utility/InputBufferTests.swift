@testable import KiltCalc
import XCTest

final class InputBufferTests: XCTestCase {
  func test_removeLast_ignores_empty_buffer() {
    var sut = InputBuffer()
    sut.removeLast()
    XCTAssertEqual(sut.count, 0)
  }

  func test_removeLast_removes_last_item() {
    var sut = InputBuffer([.dot, .unit(.inch)])
    sut.removeLast()
    XCTAssertEqual(sut.count, 1)
  }

  func test_removeLastIf_failed_condition() {
    var sut = InputBuffer([.unit(.inch)])
    sut.removeLastIf { $0.isBinaryOperator() }
    XCTAssertEqual(sut.count, 1)
  }

  func test_removeLastIf_successful_condition() {
    var sut = InputBuffer([.unit(.inch)])
    sut.removeLastIf { $0.isUnit() }
    XCTAssertEqual(sut.count, 0)
  }

  func test_removeLastWhile_failed_condition() {
    var sut = InputBuffer([.unit(.inch)])
    sut.removeLastWhile { $0.isBinaryOperator() }
    XCTAssertEqual(sut.count, 1)
  }

  func test_removeLastWhile_succeeds_and_empties_list() {
    var sut = InputBuffer([.unit(.inch), .unit(.inch)])
    sut.removeLastWhile { $0.isUnit() }
    XCTAssertEqual(sut.count, 0)
  }

  func test_removeLastWhile_successful_condition_leaves_nonempty_list() {
    var sut = InputBuffer([.dot, .unit(.inch), .unit(.inch)])
    sut.removeLastWhile { $0.isUnit() }
    XCTAssertEqual(sut.count, 1)
  }
}
