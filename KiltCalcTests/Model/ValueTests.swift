import EGTest
@testable import KiltCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_NumberMinusNumber() {
    XCTAssertEqual(Value.number(5).minus(Value.number(2)), Value.number(3))
  }

  func test_InchesMinusInches() {
    XCTAssertEqual(
      Value.inches(5).minus(Value.inches(2)),
      Value.inches(3)
    )
  }

  func test_ErrorsTimesAnythingIsError() {
    XCTAssertEqual(Value.error("a").times(Value.error("b")), Value.error("a"))
    XCTAssertEqual(Value.error("a").times(Value.number(2)), Value.error("a"))
    XCTAssertEqual(Value.error("a").times(Value.inches(2)), Value.error("a"))

    XCTAssertEqual(Value.number(2).times(Value.error("msg")), Value.error("msg"))
    XCTAssertEqual(Value.inches(3).times(Value.error("msg")), Value.error("msg"))
  }

  func test_NumberTimesNumber() {
    XCTAssertEqual(Value.number(5).times(Value.number(2)), Value.number(10))
  }

  func test_NumberTimesInches() {
    XCTAssertEqual(Value.number(5).times(Value.inches(2)), Value.inches(10))
    XCTAssertEqual(Value.inches(5).times(Value.number(2)), Value.inches(10))
  }

  func test_InchesTimesInches_isError() {
    XCTAssertEqual(
      Value.inches(5).times(Value.inches(3)),
      Value.error("error - can't handle square inches")
    )
  }

  func test_ErrorsDividedByAnythingIsError() {
    XCTAssertEqual(Value.error("a").divide(Value.error("b")), Value.error("a"))
    XCTAssertEqual(Value.error("a").divide(Value.number(2)), Value.error("a"))
    XCTAssertEqual(Value.error("a").divide(Value.inches(2)), Value.error("a"))

    XCTAssertEqual(Value.number(2).divide(Value.error("msg")), Value.error("msg"))
    XCTAssertEqual(Value.inches(3).divide(Value.error("msg")), Value.error("msg"))
  }

  func test_NumberDividedByNumber() {
    XCTAssertEqual(Value.number(10).divide(Value.number(2)), Value.number(5))
  }

  func test_NumberDividedByInches_isError() {
    XCTAssertEqual(
      Value.number(52).divide(Value.inches(2)),
      Value.error("error - can't divide number by inches")
    )
  }

  func test_InchesDividedByNumber() {
    XCTAssertEqual(Value.inches(52).divide(Value.number(4)), Value.inches(13))
  }

  func test_InchesDividedByInches_isNumber() {
    XCTAssertEqual(Value.inches(15).divide(Value.inches(3)), Value.number(5))
  }

  func test_NoNumberIsError() {
    XCTAssertEqual(Value.parse(""), .error("no value found"))
  }

  func test_NumberThenSlash_Is8ths() {
    check([
      EG("3/", expect: .number(0.375), "implicit 8ths"),
      EG("1//", expect: .number(0.0625), "implicit 16ths"),
      EG("1///", expect: .error("Too many '/' (at most 2)")),
      EG("/", expect: .error("can't start with '/'")),
      EG("/31", expect: .error("can't start with '/'")),

      EG("3/4", expect: .number(0.75), "numerator and denominator"),
      EG("3//4", expect: .error("at most one '/' between digits")),
      EG("1/2/3", expect: .error("use \u{00f7} for complicated fractions")),

      EG("1.25", expect: .number(1.25), "simple decimal"),
      EG("1..25", expect: .error("too many '.'")),
      EG("1.2.3", expect: .error("too many '.'")),
    ]) {
      EGAssertEqual(Value.parse($0.input), $0)
    }
  }
}
