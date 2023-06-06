@testable import InchCalc
import XCTest

final class CalculatorTests: XCTestCase {
  private let calc = Calculator()

  func test_calculatorStartsZero() throws {
    XCTAssertEqual(calc.display, "0")
  }

  func test_displayChangesWhenDigitsAdded() {
    calc.enter(.digit(4))
    calc.enter(.digit(2))
    XCTAssertEqual(calc.display, "42")
  }

  func test_EqualsEvaluatesTheCurrentDisplay() {
    calc.enter(.digit(4))
    calc.enter(.equals)
    calc.enter(.digit(2))
    XCTAssertEqual(calc.display, "2")
  }

  func test_ClearResetsDisplayAndEntering() {
    calc.enter(.digit(4))
    calc.enter(.clear)
    XCTAssertEqual(calc.display, "0")
  }

  func test_EnterEvaluatesPendingString() {
    calc.enter(.digit(0))
    calc.enter(.digit(0))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "0")
  }

  func test_EnterWithoutPendingUsesZero() {
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "0")
  }

  fileprivate func overflowValue(_ calc: Calculator) {
    (1...350).forEach { _ in
      calc.enter(.digit(9))
    }
  }

  func test_ParsingOverflowValueYieldsError() {
    overflowValue(calc)
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "number too big or too small")
  }

  func test_ClearResetsError() {
    overflowValue(calc)
    calc.enter(.equals)

    calc.enter(.clear)
    XCTAssertEqual("0", calc.display)
  }

  func test_InchesCreatesValueWithUnits() {
    calc.enter(.digit(3))
    calc.enter(.unit(.inch))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "3 in")
  }

  func test_InchesCanAccumulate() {
    calc.enter(.digit(3))
    calc.enter(.unit(.inch))
    calc.enter(.digit(6))
    calc.enter(.unit(.inch))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "9 in")
  }

  func test_DigitsAndUnitsMustCorrespond() {
    calc.enter(.digit(3))
    calc.enter(.unit(.inch))
    calc.enter(.digit(6))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "numbers and units don't match")
  }

  func test_NumberPlusNumber() {
    calc.enter(.digit(3))
    calc.enter(.add)
    calc.enter(.digit(6))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "9")
  }

  func test_NumberPlusInchesIsError() {
    calc.enter(.digit(3))
    calc.enter(.add)
    calc.enter(.digit(6))
    calc.enter(.unit(.inch))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "error - mixing inches and numbers")
  }

  func test_InchesPlusNumberIsError() {
    calc.enter(.digit(3))
    calc.enter(.unit(.inch))
    calc.enter(.add)
    calc.enter(.digit(6))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "error - mixing inches and numbers")
  }

  func test_InchesPlusInchesIsInches() {
    calc.enter(.digit(9))
    calc.enter(.unit(.inch))
    calc.enter(.add)
    calc.enter(.digit(6))
    calc.enter(.unit(.inch))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "1 ft 3 in")
  }

  func test_OperatorShowsInDisplay() {
    calc.enter(.digit(9))
    calc.enter(.add)
    XCTAssertEqual(calc.display, "9+")
  }

  func test_LastOperatorWins() {
    calc.enter(.digit(9))
    calc.enter(.multiply)
    calc.enter(.add)
    calc.enter(.digit(3))
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "12")
  }

  func test_TrailingBinaryOperatorIsAnError() {
    calc.enter(.digit(9))
    calc.enter(.multiply)
    calc.enter(.equals)
    XCTAssertEqual(calc.display, "expression can't end with an operator")
  }
}
