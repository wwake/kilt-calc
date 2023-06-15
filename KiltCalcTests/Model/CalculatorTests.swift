@testable import KiltCalc
import XCTest

final class CalculatorTests: XCTestCase {
  private let calc = Calculator()
  private let addOp = Entry.binary(Operator(name: "+", precedence: 3, evaluate: +))
  private let subtractOp = Entry.binary(Operator(name: "-", precedence: 3, evaluate: -))
  private let multiplyOp = Entry.binary(Operator(name: "*", precedence: 5, evaluate: *))
  private let divideOp = Entry.binary(Operator(name: "÷", precedence: 5, evaluate: /))
  private let negate = Entry.unary(Operator(name: "plusOrMinus", precedence: 99, evaluate: { a, _ in a.negate() }))

  private let overflowValue = String(repeating: "9", count: 350)

  private func enter(_ input: String) {
    var firstLetter: Character = " "

    input.forEach { keyName in
      switch keyName {
      case " ":
        break

      case "=":
        calc.enter(.equals)

      case "<":
        calc.enter(.backspace)

      case "C", "R":
        if firstLetter == "M" {
          calc.enter(.tbd("M\(keyName)"))
          firstLetter = " "
        } else {
          calc.enter(.clear)
        }

      case "0"..."9":
        calc.enter(.digit(Int(String(keyName))!))

      case "y", "f", "i", "M":
        firstLetter = keyName

      case "d":
        if firstLetter == "y" {
          calc.enter(.unit(.yard))
          firstLetter = " "
        }

      case "t":
        if firstLetter == "f" {
          calc.enter(.unit(.foot))
          firstLetter = " "
        }

      case "n":
        if firstLetter == "i" {
          calc.enter(.unit(.inch))
          firstLetter = " "
        }

      case "(":
        calc.enter(.leftParend)

      case ")":
        calc.enter(.rightParend)

      case "+":
        calc.enter(addOp)

      case "-":
        calc.enter(subtractOp)

      case "*":
        calc.enter(multiplyOp)

      case ":":
        calc.enter(divideOp)

      case "~":
        calc.enter(negate)

      default:
        // TBD: %, ., M-, M+
        calc.enter(.tbd("\(firstLetter)\(keyName)"))
        firstLetter = " "
      }
    }
  }

  func test_calculatorStartsZero() throws {
    XCTAssertEqual(calc.display, "0")
  }

  func test_displayChangesWhenDigitsAdded() {
    enter("42")
    XCTAssertEqual(calc.display, "42")
  }

  func test_EqualsEvaluatesTheCurrentDisplay() {
    enter("4=2")
    XCTAssertEqual(calc.display, "2")
  }

  func test_ClearResetsDisplayAndEntering() {
    enter("4C")
    XCTAssertEqual(calc.display, "0")
  }

  func test_EnterEvaluatesPendingString() {
    enter("00=")
    XCTAssertEqual(calc.display, "0")
  }

  func test_EnterWithoutPendingUsesZero() {
    enter("=")
    XCTAssertEqual(calc.display, "0")
  }

  func test_ParsingOverflowValueYieldsError() {
    enter(overflowValue + "=")
    XCTAssertEqual(calc.display, "number too big or too small")
  }

  func test_ClearResetsError() {
    enter(overflowValue + "=C")
    XCTAssertEqual("0", calc.display)
  }

  func test_InchesCreatesValueWithUnits() {
    enter("3in=")
    XCTAssertEqual(calc.display, "3 in")
  }

  func test_InchesCanAccumulate() {
    enter("3in6in=")
    XCTAssertEqual(calc.display, "9 in")
  }

  func test_DigitsAndUnitsMustCorrespond() {
    enter("3in6=")
    XCTAssertEqual(calc.display, "numbers and units don't match")
  }

  func test_NumberPlusNumber() {
    enter("3+6=")
    XCTAssertEqual(calc.display, "9")
  }

  func test_NumberPlusInchesIsError() {
    enter("3+6in=")
    XCTAssertEqual(calc.display, "error - mixing inches and numbers")
  }

  func test_InchesPlusNumberIsError() {
    enter("3in+6=")
    XCTAssertEqual(calc.display, "error - mixing inches and numbers")
  }

  func test_InchesPlusInchesIsInches() {
    enter("9in+6in=")
    XCTAssertEqual(calc.display, "15 in")
  }

  func test_OperatorShowsInDisplay() {
    enter("9+")
    XCTAssertEqual(calc.display, "9+")
  }

  func test_LastOperatorWins() {
    enter("9*+3=")
    XCTAssertEqual(calc.display, "12")
  }

  func test_TrailingBinaryOperatorIsAnError() {
    enter("9*=")
    XCTAssertEqual(calc.display, "expression can't end with an operator")
  }

  func test_PlusOrMinusOnNumber() {
    enter("64~=")
    XCTAssertEqual(calc.display, "-64")
  }

  func test_DigitAfterUnaryOpIsPlacedBeforeIt() {
    enter("6~4=")
    XCTAssertEqual(calc.display, "-64")
  }

  func test_UnitValueThenUnaryOp() {
    enter("1yd27in~=")
    XCTAssertEqual(calc.display, "-63 in")
  }

  func test_DigitAfterUnaryOpOnUnitIsLeftThere() {
    enter("6in~4=")
    XCTAssertEqual(calc.display, "numbers and units don't match")
  }

  func test_DigitNegatePlusdDigit_ShouldNegateAndAdd() {
    enter("6~+4=")
    XCTAssertEqual(calc.display, "-2")
  }

  func test_PlusOrMinusFirst_IsError() {
    enter("~=")
    XCTAssertEqual(calc.display, "no value found")
  }

  func test_TooManyLeftParends() {
    enter("(=")
    XCTAssertEqual(calc.display, "error - unbalanced parentheses")
  }

  func test_TooManyRightParends() {
    enter(")=")
    XCTAssertEqual(calc.display, "error - unbalanced parentheses")
  }

  func test_DefaultsToDisplayInches() {
    calc.imperialFormat = ImperialFormatter.inches
    enter("63in=")
    XCTAssertEqual(calc.display, "63 in")
  }

  func test_ChangingUnitDisplay() {
    calc.imperialFormat = ImperialFormatter.yardFeetInches

    enter("63in=")
    XCTAssertEqual(calc.display, "1 yd 2 ft 3 in")

    calc.imperialFormat = ImperialFormatter.inches
    XCTAssertEqual(calc.display, "63 in")
  }

  func test_RoundingTo8thsWithNoIntegerPart() {
    enter("3:8=")
    XCTAssertEqual(calc.display, "3/8")
  }

  func test_RoundingTo8thsWithIntegerPart() {
    enter("25:8=")
    XCTAssertEqual(calc.display, "3·1/8")
  }

  func test_RoundingTo8thsWithNumeratorRoundedTo8() {
    enter("199:100=")
    XCTAssertEqual(calc.display, "2⊖")
  }

  func test_RoundingNegativeNumbers() {
    enter("199~:100=")
    XCTAssertEqual(calc.display, "-2⊕")
  }

  func test_RoundingNegativeNumbersSlightlyBig() {
    enter("201~:100=")
    XCTAssertEqual(calc.display, "-2⊖")
  }

  func test_RoundingFractionOnlyNegativeNumbers() {
    enter("99~:100=")
    XCTAssertEqual(calc.display, "-1⊕")
  }

  func test_RoundingTo16thsWithNoIntegerPart() {
    enter("15:16=")
    XCTAssertEqual(calc.display, "15/16")
  }

  func test_RoundingTo16thsWithPlus() {
    enter("154:160=")
    XCTAssertEqual(calc.display, "15/16⊕")
  }

  func test_RoundingTo16thsWithMinus() {
    enter("148:160=")
    XCTAssertEqual(calc.display, "15/16⊖")
  }
}
