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

  private func display(_ input: String) -> String {
    let (_, answer) = expressionResult(input)
    return answer
  }

  private func expressionResult(_ input: String) -> ((String, String), String) {
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
    return (calc.previous, calc.display)
  }

  func test_calculatorStartsZero() throws {
    XCTAssertEqual(Calculator().display, "0")
  }

  func test_editing() {
    check([
      EG("", expect: "0", "display starts with 0"),
      EG("42", expect: "42", "display changes when digits added"),
      EG("9876543210", expect: "9876543210", "all digits"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_ClearResetsDisplayAndEntering() {
    XCTAssertEqual(display("4C"), "0")
  }

  func test_Evaluation() {
    check([
      EG("4=2", expect: "2", "display shows new expression"),
      EG("00=", expect: "0", "a number evaluates to itself"),
      EG("=", expect: "0", "nothing pending => 0"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_EqualsSavesExpressionText() {
    let (expression, display) = expressionResult("1+2=")
    XCTAssertEqual(expression.0, "1+2")
    XCTAssertEqual(expression.1, "3")
    XCTAssertEqual(display, "3")
  }

  func test_overflowHandling() {
    check([
      EG(overflowValue + "=", expect: "number too big or too small", "overflow"),
      EG(overflowValue + "=C", expect: "0", "clear resets overflow"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_enteringUnits() {
    check([
      EG("3in=", expect: "3 in", "inch creates unit"),
      EG("3in6in=", expect: "9 in", "inches can accumulate"),
      EG("3in6=", expect: "numbers and units don't match"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_addition() {
    check([
      EG("3+6=", expect: "9", "number + number"),
      EG("9in+6in=", expect: "15 in", "inches + inches"),
      EG("3+6in=", expect: "error - mixing inches and numbers"),
      EG("3in+6=", expect: "error - mixing inches and numbers"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_enteringOperators() {
    check([
      EG("9+", expect: "9+", "operator shows in display"),
      EG("9*+3=", expect: "12", "last operator wins"),
      EG("9*=", expect: "expression can't end with an operator"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_plusOrMinus() {
    check([
      EG("64~=", expect: "-64", "plus-or-minus on number"),
      EG("6~4=", expect: "-64", "digit after unary moves in front"),
      EG("1yd27in~=", expect: "-63 in", "plus-or-minus on unit"),
      EG("6in~4=", expect: "numbers and units don't match", "digit after unary op on unit stays there"),
      EG("6~+4=", expect: "-2", "unary before binary ops"),
      EG("~=", expect: "no value found"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_TooManyLeftParends() {
    XCTAssertEqual(display("(="), "error - unbalanced parentheses")
  }

  func test_TooManyRightParends() {
    XCTAssertEqual(display(")="), "error - unbalanced parentheses")
  }

  func test_UnitDisplayMode() {
    check([
      EG("63in=", expect: "63 in", "default is inches"),
      EG("Y63in=", expect: "1 yd 2 ft 3 in", "yd-ft-in"),
      EG("Y63in=I", expect: "63 in", "can change mode"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }

  func test_Rounding() {
    check([
      EG("3:8=", expect: "3/8", "round to 8ths w/no int part"),
      EG("25:8=", expect: "3·1/8", "round to 8ths w/int part"),
      EG("199:100=", expect: "2⊖", "round to 8ths w/numerator rounded to whole number"),
      EG("199~:100=", expect: "-2⊕", "round to 8ths w/negative"),
      EG("201~:100=", expect: "-2⊖", "round 8ths to whole number, slightly big"),
      EG("99~:100=", expect: "-1⊕", "round negative to whole number, slightly small"),
      EG("15:16=", expect: "15/16", "round to 16ths, no int part"),
      EG("154:160=", expect: "15/16⊕", "round to 16ths, slightly small"),
      EG("148:160=", expect: "15/16⊖", "round to 16ths, slightly big"),

      EG("I154in:160=", expect: "15/16⊕ in", "round with units - inches"),
      EG("Y5914in:160=", expect: "1 yd 15/16⊕ in", "round with units yd-ft-in"),
    ]) {
      EGAssertEqual(display($0.input), $0)
    }
  }
}
