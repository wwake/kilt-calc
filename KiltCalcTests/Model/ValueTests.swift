import EGTest
@testable import KiltCalc
import XCTest

final class ValueTests: XCTestCase {
  func test_Plus() {
    check([
      EG((Value.error("a"), Value.number(2)), expect: .error("a")),
      EG((Value.number(3), Value.error("b")), expect: .error("b")),
      EG((Value.error("a"), Value.error("a")), expect: .error("a")),

      EG((Value.error("a"), Value.inches(2)), expect: .error("a")),
      EG((Value.inches(3), Value.error("b")), expect: .error("b")),

      EG((Value.number(5), Value.number(2)), expect: .number(7)),
      EG((Value.inches(50), Value.inches(2)), expect: .inches(52)),

      EG((Value.number(5), Value.inches(2)), expect: .error("error - mixing inches and numbers")),
      EG((Value.number(0), Value.inches(2)), expect: .inches(2)),
      EG((Value.number(6), Value.inches(0)), expect: .number(6)),
      EG((Value.number(0), Value.inches(0)), expect: .number(0)),

      EG((Value.inches(5), Value.number(2)), expect: .error("error - mixing inches and numbers")),
      EG((Value.inches(0), Value.number(2)), expect: .number(2)),
      EG((Value.inches(2), Value.number(0)), expect: .inches(2)),
      EG((Value.inches(0), Value.number(0)), expect: .number(0)),

      EG((Value.inches(5), Value.inches(-5)), expect: .number(0)),
    ]) {
      EGAssertEqual($0.input.0.plus($0.input.1), $0)
    }
  }

  func test_Minus() {
    check([
      EG((Value.error("a"), Value.number(2)), expect: Value.error("a")),
      EG((Value.number(3), Value.error("b")), expect: .error("b")),
      EG((Value.error("a"), Value.error("a")), expect: .error("a")),

      EG((Value.error("a"), Value.inches(2)), expect: Value.error("a")),
      EG((Value.inches(3), Value.error("b")), expect: .error("b")),

      EG((Value.number(5), Value.number(2)), expect: .number(3)),
      EG((Value.inches(50), Value.inches(2)), expect: .inches(48)),

      EG((Value.number(5), Value.inches(2)), expect: .error("error - mixing inches and numbers")),
      EG((Value.number(0), Value.inches(2)), expect: .inches(-2)),
      EG((Value.number(6), Value.inches(0)), expect: .number(6)),
      EG((Value.number(0), Value.inches(0)), expect: .number(0)),

      EG((Value.inches(5), Value.number(2)), expect: .error("error - mixing inches and numbers")),
      EG((Value.inches(0), Value.number(2)), expect: .number(-2)),
      EG((Value.inches(2), Value.number(0)), expect: .inches(2)),
      EG((Value.inches(0), Value.number(0)), expect: .number(0)),

      EG((Value.inches(5), Value.inches(5)), expect: .number(0)),
    ]) {
      EGAssertEqual($0.input.0.minus($0.input.1), $0)
    }
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

  func test_InchesTimesInches_isErrorExcept0() {
    XCTAssertEqual(
      Value.inches(5).times(Value.inches(3)),
      Value.error("error - can't handle square inches")
    )

    XCTAssertEqual(
      Value.inches(0).times(Value.inches(31)),
      Value.number(0)
    )

    XCTAssertEqual(
      Value.inches(3).times(Value.inches(0)),
      Value.number(0)
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

  func test_NumbersWithOrWithoutDecimalPointsOrFractions() {
    check([
      EG("/", expect: .error("can't start with '/'")),
      EG("/31", expect: .error("can't start with '/'")),
      EG("3/", expect: .error("missing denominator")),
      EG("314.1/", expect: .error("missing denominator")),

      EG("1//", expect: .error("simple fractions only (at most one '/'")),
      EG("1///", expect: .error("simple fractions only (at most one '/'")),
      EG("314.1//", expect: .error("simple fractions only (at most one '/'")),
      EG("3//4", expect: .error("simple fractions only (at most one '/'")),
      EG("1/2/3", expect: .error("simple fractions only (at most one '/'")),

      EG("3/4", expect: .number(0.75), "numerator and denominator"),

      EG("1.25", expect: .number(1.25), "simple decimal"),
      EG("1..25", expect: .error("too many '.'")),
      EG("1.2.3", expect: .error("too many '.'")),

      EG("314.1/2", expect: .number(314.5), "explicit fraction"),
    ]) {
      EGAssertEqual(Value.parse($0.input), $0)
    }
  }
}
