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

  func test_EqualsEvaluatesTheCurrentDisplay() {
    let calc = Calculator()
    calc.digit("4")
    calc.enter("=")
    calc.digit("2")
    XCTAssertEqual(calc.display, "2")
  }

  func test_ClearResetsDisplayAndEntering() {
    let calc = Calculator()
    calc.digit("4")
    calc.clear("C")
    XCTAssertEqual(calc.display, "0")
    XCTAssertFalse(calc.alreadyEnteringNewNumber)
  }

  func test_EnterEvaluatesPendingString() {
    let calc = Calculator()
    calc.digit("0")
    calc.digit("0")
    calc.enter("=")
    XCTAssertEqual(calc.display, "0")
  }

  func test_EnterWithoutPendingUsesZero() {
    let calc = Calculator()
    calc.enter("=")
    XCTAssertEqual(calc.display, "0")
  }

  fileprivate func overflowValue(_ calc: Calculator) {
    (1...350).forEach { _ in
      calc.digit("9")
    }
  }

  func test_OverflowValueYieldsError() {
    let calc = Calculator()

    overflowValue(calc)
    calc.enter("=")
    XCTAssertEqual(calc.display, "error")
  }

  func test_ClearResetsError() {
    let calc = Calculator()
    overflowValue(calc)
    calc.enter("=")

    calc.clear("C")
    XCTAssertEqual("0", calc.display)
  }
}
