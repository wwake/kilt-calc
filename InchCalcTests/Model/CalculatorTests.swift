@testable import InchCalc
import XCTest

final class CalculatorTests: XCTestCase {
  private let calc = Calculator()

  func test_calculatorStartsZero() throws {
    XCTAssertEqual(calc.display, "0")
  }

  func test_displayChangesWhenDigitsAdded() {
    calc.digit("4")
    calc.digit("2")
    XCTAssertEqual(calc.display, "42")
  }

  func test_EqualsEvaluatesTheCurrentDisplay() {
    calc.digit("4")
    calc.enter("=")
    calc.digit("2")
    XCTAssertEqual(calc.display, "2")
  }

  func test_ClearResetsDisplayAndEntering() {
    calc.digit("4")
    calc.clear("C")
    XCTAssertEqual(calc.display, "0")
    XCTAssertFalse(calc.alreadyEnteringNewNumber)
  }

  func test_EnterEvaluatesPendingString() {
    calc.digit("0")
    calc.digit("0")
    calc.enter("=")
    XCTAssertEqual(calc.display, "0")
  }

  func test_EnterWithoutPendingUsesZero() {
    calc.enter("=")
    XCTAssertEqual(calc.display, "0")
  }

  fileprivate func overflowValue(_ calc: Calculator) {
    (1...350).forEach { _ in
      calc.digit("9")
    }
  }

  func test_OverflowValueYieldsError() {
    overflowValue(calc)
    calc.enter("=")
    XCTAssertEqual(calc.display, "number too big or too small")
  }

  func test_ClearResetsError() {
    overflowValue(calc)
    calc.enter("=")

    calc.clear("C")
    XCTAssertEqual("0", calc.display)
  }

  func test_InchesCreatesValueWithUnits() {
    calc.digit("3")
    calc.unit("in")
    calc.enter("=")
    XCTAssertEqual(calc.display, "3 in")
  }

  func test_InchesCanAccumulate() {
    calc.digit("3")
    calc.unit("in")
    calc.digit("6")
    calc.unit("in")
    calc.enter("=")
    XCTAssertEqual(calc.display, "9 in")
  }

  func test_DigitsAndUnitsMustCorrespond() {
    calc.digit("3")
    calc.unit("in")
    calc.digit("6")
    calc.enter("=")
    XCTAssertEqual(calc.display, "numbers and units don't match")
  }

  func test_NumberPlusNumber() {
    calc.digit("3")
    calc.op("+")
    calc.digit("6")
    calc.enter("=")
    XCTAssertEqual(calc.display, "9")
  }

  func test_NumberPlusInchesIsError() {
    calc.digit("3")
    calc.op("+")
    calc.digit("6")
    calc.unit("in")
    calc.enter("=")
    XCTAssertEqual(calc.display, "error - mixing inches and numbers")
  }

  func test_InchesPlusNumberIsError() {
    calc.digit("3")
    calc.unit("in")
    calc.op("+")
    calc.digit("6")
    calc.enter("=")
    XCTAssertEqual(calc.display, "error - mixing inches and numbers")
  }

  func test_InchesPlusInchesIsInches() {
    calc.digit("9")
    calc.unit("in")
    calc.op("+")
    calc.digit("6")
    calc.unit("in")
    calc.enter("=")
    XCTAssertEqual(calc.display, "1 ft 3 in")
  }

  func test_OperatorShowsInDisplay() {
    calc.digit("9")
    calc.op("+")
    XCTAssertEqual(calc.display, "9+")
  }

  func test_LastOperatorWins() {
    calc.digit("9")
    calc.op("*")
    calc.op("+")
    calc.digit("3")
    calc.enter("=")
    XCTAssertEqual(calc.display, "12")
  }

  func test_TrailingBinaryOperatorIsAnError() {
    calc.digit("9")
    calc.op("*")
    calc.enter("=")
    XCTAssertEqual(calc.display, "expression can't end with an operator")
  }
}
