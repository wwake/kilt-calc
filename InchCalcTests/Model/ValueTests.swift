@testable import InchCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_error() {
    XCTAssertEqual(Value.error("error message").format(ImperialFormatter.asInches), "error message")
  }

  func test_numberWithoutUnits() {
    XCTAssertEqual(Value.number(42).format(ImperialFormatter.asInches), "42")
  }

  func test_zeroInches() throws {
    XCTAssertEqual(Value.inches(0).format(ImperialFormatter.asInches), "0 in")
  }

  func test_ValueWithYardFeetInchFormatter() throws {
    XCTAssertEqual(Value.inches(63).format(ImperialFormatter.asYardFeetInches), "1 yd 2 ft 3 in")
  }

  func test_NumberMinusNumber() {
    XCTAssertEqual(Value.number(5).minus(Value.number(2)).format(ImperialFormatter.asInches), "3")
  }

  func test_InchesMinusInches() {
    XCTAssertEqual(Value.inches(5).minus(Value.inches(2)).format(ImperialFormatter.asInches), "3 in")
  }

  func test_ErrorsTimesAnythingIsError() {
    XCTAssertEqual(Value.error("a").times(Value.error("b")).format(ImperialFormatter.asInches), "a")
    XCTAssertEqual(Value.error("a").times(Value.number(2)).format(ImperialFormatter.asInches), "a")
    XCTAssertEqual(Value.error("a").times(Value.inches(2)).format(ImperialFormatter.asInches), "a")

    XCTAssertEqual(Value.number(2).times(Value.error("msg")).format(ImperialFormatter.asInches), "msg")
    XCTAssertEqual(Value.inches(3).times(Value.error("msg")).format(ImperialFormatter.asInches), "msg")
  }

  func test_NumberTimesNumber() {
    XCTAssertEqual(Value.number(5).times(Value.number(2)).format(ImperialFormatter.asInches), "10")
  }

  func test_NumberTimesInches() {
    XCTAssertEqual(Value.number(5).times(Value.inches(2)).format(ImperialFormatter.asInches), "10 in")
    XCTAssertEqual(Value.inches(5).times(Value.number(2)).format(ImperialFormatter.asInches), "10 in")
  }

  func test_InchesTimesInches_isError() {
    XCTAssertEqual(
      Value.inches(5).times(Value.inches(3)).format(ImperialFormatter.asInches),
      "error - can't handle square inches"
    )
  }

  func test_ErrorsDividedByAnythingIsError() {
    XCTAssertEqual(Value.error("a").divide(Value.error("b")).format(ImperialFormatter.asInches), "a")
    XCTAssertEqual(Value.error("a").divide(Value.number(2)).format(ImperialFormatter.asInches), "a")
    XCTAssertEqual(Value.error("a").divide(Value.inches(2)).format(ImperialFormatter.asInches), "a")

    XCTAssertEqual(Value.number(2).divide(Value.error("msg")).format(ImperialFormatter.asInches), "msg")
    XCTAssertEqual(Value.inches(3).divide(Value.error("msg")).format(ImperialFormatter.asInches), "msg")
  }

  func test_NumberDividedByNumber() {
    XCTAssertEqual(Value.number(10).divide(Value.number(2)).format(ImperialFormatter.asInches), "5")
  }

  func test_NumberDividedByInches_isError() {
    XCTAssertEqual(
      Value.number(52).divide(Value.inches(2)).format(ImperialFormatter.asInches),
      "error - can't divide number by inches"
    )
  }

  func test_InchesDividedByNumber() {
    XCTAssertEqual(Value.inches(52).divide(Value.number(4)).format(ImperialFormatter.asInches), "13 in")
  }

  func test_InchesDividedByInches_isNumber() {
    XCTAssertEqual(Value.inches(15).divide(Value.inches(3)).format(ImperialFormatter.asInches), "5")
  }
}
