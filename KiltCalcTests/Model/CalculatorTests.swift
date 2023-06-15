import EGTest
@testable import KiltCalc
import XCTest

public func EGAssertEqual<T: Equatable, Input>(_ actual: T, _ expected: EG<Input, T>) {
  XCTAssertEqual(
    actual, expected.expect, expected.message, file: expected.file, line: expected.line
  )
}

final class CalculatorTests: XCTestCase {
  private let calc = Calculator()
  private let addOp = Entry.binary(Operator(name: "+", precedence: 3, evaluate: +))
  private let subtractOp = Entry.binary(Operator(name: "-", precedence: 3, evaluate: -))
  private let multiplyOp = Entry.binary(Operator(name: "*", precedence: 5, evaluate: *))
  private let divideOp = Entry.binary(Operator(name: "÷", precedence: 5, evaluate: /))
  private let negate = Entry.unary(Operator(name: "plusOrMinus", precedence: 99, evaluate: { a, _ in a.negate() }))

  private let overflowValue = String(repeating: "9", count: 350)

  private func enter(_ input: String) -> String {
    let calc = Calculator()
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

      case "I":
        calc.imperialFormat = ImperialFormatter.inches

      case "Y":
        calc.imperialFormat = ImperialFormatter.yardFeetInches

      default:
        // TBD: %, ., M-, M+
        calc.enter(.tbd("\(firstLetter)\(keyName)"))
        firstLetter = " "
      }
    }
    return calc.display
  }

  func test_calculatorStartsZero() throws {
    XCTAssertEqual(Calculator().display, "0")
  }

  func test_editing() {
    check([
      EG("", expect: "0", "display starts with 0"),
      EG("42", expect: "42", "display changes when digits added"),
    ]) {
      EGAssertEqual(enter($0.input), $0)
    }
  }

  func test_EqualsEvaluatesTheCurrentDisplay() {
    XCTAssertEqual(enter("4=2"), "2")
  }

  func test_ClearResetsDisplayAndEntering() {
    XCTAssertEqual(enter("4C"), "0")
  }

  func test_EnterEvaluatesPendingString() {
    XCTAssertEqual(enter("00="), "0")
  }

  func test_EnterWithoutPendingUsesZero() {
    XCTAssertEqual(enter("="), "0")
  }

  func test_overflowHandling() {
    check([
      EG(overflowValue + "=", expect: "number too big or too small", "overflow"),
      EG(overflowValue + "=C", expect: "0", "clear resets overflow"),
    ]) {
      EGAssertEqual(enter($0.input), $0)
    }
  }

  func test_enteringUnits() {
    check([
      EG("3in=", expect: "3 in", "inch creates unit"),
      EG("3in6in=", expect: "9 in", "inches can accumulate"),
      EG("3in6=", expect: "numbers and units don't match"),
    ]) {
      EGAssertEqual(enter($0.input), $0)
    }
  }

  func test_addition() {
    check([
      EG("3+6=", expect: "9", "number + number"),
      EG("9in+6in=", expect: "15 in", "inches + inches"),
      EG("3+6in=", expect: "error - mixing inches and numbers"),
      EG("3in+6=", expect: "error - mixing inches and numbers"),
    ]) {
      EGAssertEqual(enter($0.input), $0)
    }
  }

  func test_enteringOperators() {
    check([
      EG("9+", expect: "9+", "operator shows in display"),
      EG("9*+3=", expect: "12", "last operator wins"),
      EG("9*=", expect: "expression can't end with an operator"),
    ]) {
      EGAssertEqual(enter($0.input), $0)
    }
  }

  func test_OperatorShowsInDisplay() {
    XCTAssertEqual(enter("9+"), "9+")
  }

  func test_LastOperatorWins() {
    XCTAssertEqual(enter("9*+3="), "12")
  }

  func test_TrailingBinaryOperatorIsAnError() {
    XCTAssertEqual(enter("9+="), "expression can't end with an operator")
  }

  func test_PlusOrMinusOnNumber() {
    XCTAssertEqual(enter("64~="), "-64")
  }

  func test_DigitAfterUnaryOpIsPlacedBeforeIt() {
    XCTAssertEqual(enter("6~4="), "-64")
  }

  func test_UnitValueThenUnaryOp() {
    XCTAssertEqual(enter("1yd27in~="), "-63 in")
  }

  func test_DigitAfterUnaryOpOnUnitIsLeftThere() {
    XCTAssertEqual(enter("6in~4="), "numbers and units don't match")
  }

  func test_DigitNegatePlusdDigit_ShouldNegateAndAdd() {
    XCTAssertEqual(enter("6~+4="), "-2")
  }

  func test_PlusOrMinusFirst_IsError() {
    XCTAssertEqual(enter("~="), "no value found")
  }

  func test_TooManyLeftParends() {
    XCTAssertEqual(enter("(="), "error - unbalanced parentheses")
  }

  func test_TooManyRightParends() {
    XCTAssertEqual(enter(")="), "error - unbalanced parentheses")
  }

  func test_DefaultsToDisplayInches() {
    XCTAssertEqual(enter("63in="), "63 in")
  }

  func test_ChangingUnitDisplay() {
    XCTAssertEqual(enter("Y63in=I"), "63 in")
  }

  func test_RoundingTo8thsWithNoIntegerPart() {
    XCTAssertEqual(enter("3:8="), "3/8")
  }

  func test_RoundingTo8thsWithIntegerPart() {
    XCTAssertEqual(enter("25:8="), "3·1/8")
  }

  func test_RoundingTo8thsWithNumeratorRoundedTo8() {
    XCTAssertEqual(enter("199:100="), "2⊖")
  }

  func test_RoundingNegativeNumbers() {
    XCTAssertEqual(enter("199~:100="), "-2⊕")
  }

  func test_RoundingNegativeNumbersSlightlyBig() {
    XCTAssertEqual(enter("201~:100="), "-2⊖")
  }

  func test_RoundingFractionOnlyNegativeNumbers() {
    XCTAssertEqual(enter("99~:100="), "-1⊕")
  }

  func test_RoundingTo16thsWithNoIntegerPart() {
    XCTAssertEqual(enter("15:16="), "15/16")
  }

  func test_RoundingTo16thsWithPlus() {
    XCTAssertEqual(enter("154:160="), "15/16⊕")
  }

  func test_RoundingTo16thsWithMinus() {
    XCTAssertEqual(enter("148:160="), "15/16⊖")
  }
}
