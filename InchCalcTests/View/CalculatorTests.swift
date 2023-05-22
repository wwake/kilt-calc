@testable import InchCalc
import XCTest

final class CalculatorTests: XCTestCase {
  func test_calculatorStartsZero() throws {
    let calc = Calculator()
    XCTAssertEqual(calc.display, "0")
  }

  func test_displayChangesWhenDigitsAdded() {
    let calc = Calculator()
    calc.digit("4")
    calc.digit("2")
    XCTAssertEqual(calc.display, "42")
  }
}
