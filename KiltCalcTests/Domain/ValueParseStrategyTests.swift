import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class ValueParseStrategyTests: XCTestCase {
  func test_NoNumberIsError() throws {
    XCTAssertEqual(try ValueParseStrategy().parse(""), .error("no value found"))
  }

  func test_NumbersWithOrWithoutDecimalPointsOrFractions() throws {
    try check([
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
      EGAssertEqual(try ValueParseStrategy().parse($0.input), $0)
    }
  }

  func test_InchesWithOrWithoutDecimalPointsOrFractions() throws {
    try check([
      EG("/in", expect: .error("can't start with '/'")),
      EG("/31 in", expect: .error("can't start with '/'")),
      EG("3/in", expect: .error("missing denominator")),
      EG("314.1/in", expect: .error("missing denominator")),

      EG("1// in", expect: .error("simple fractions only (at most one '/'")),
      EG("1///in", expect: .error("simple fractions only (at most one '/'")),
      EG("314.1//in", expect: .error("simple fractions only (at most one '/'")),
      EG("3//4in", expect: .error("simple fractions only (at most one '/'")),
      EG("1/2/3in", expect: .error("simple fractions only (at most one '/'")),

      EG("3/4 in", expect: .inches(0.75), "numerator and denominator"),

      EG("1.25in", expect: .inches(1.25), "simple decimal"),
      EG("1..25in", expect: .error("too many '.'")),
      EG("1.2.3in", expect: .error("too many '.'")),

      EG("314.1/2in", expect: .inches(314.5), "explicit fraction"),
    ]) {
      EGAssertEqual(try ValueParseStrategy().parse($0.input), $0)
    }
  }

  func test_InchesWithMidDotInsteadOfDecimalPoint() throws {
    try check([
      EG("314•1/in", expect: .error("missing denominator")),

      EG("314•1//in", expect: .error("simple fractions only (at most one '/'")),

      EG("1•25in", expect: .inches(1.25), "simple decimal"),
      EG("1••25in", expect: .error("too many '.'")),
      EG("1•2•3in", expect: .error("too many '.'")),

      EG("314•1/2in", expect: .inches(314.5), "explicit fraction"),
    ]) {
      EGAssertEqual(try ValueParseStrategy().parse($0.input), $0)
    }
  }
}
