import EGTest
@testable import KiltCalc
import XCTest

final class ValueParseStrategyTests: XCTestCase {
  func test_NoNumberIsError() throws {
    let input = ""
    let expected = "No value found"

    XCTAssertThrowsError(
      try ValueParseStrategy().parse(input),
      "Expected '\(expected)'"
    ) { error in
      let actual = error as! String
      XCTAssertEqual(actual, expected)
    }
  }

  func test_LegalNumbersWithOrWithoutDecimalPointsOrFractions() throws {
    try check([
      EG("3/4", expect: .number(0.75), "numerator and denominator"),
      EG("1.25", expect: .number(1.25), "simple decimal"),
      EG("314.1/2", expect: .number(314.5), "explicit fraction"),
    ]) {
      EGAssertEqual(try ValueParseStrategy().parse($0.input), $0)
    }
  }

  func test_ErrorNumbersWithOrWithoutDecimalPointsOrFractions() throws {
    try check([
      EG("/", expect: "can't start with '/'"),
      EG("/31", expect: "can't start with '/'"),
      EG("3/", expect: "missing denominator"),
      EG("314.1/", expect: "missing denominator"),

      EG("1//", expect: "simple fractions only (at most one '/'"),
      EG("1///", expect: "simple fractions only (at most one '/'"),
      EG("314.1//", expect: "simple fractions only (at most one '/'"),
      EG("3//4", expect: "simple fractions only (at most one '/'"),
      EG("1/2/3", expect: "simple fractions only (at most one '/'"),

      EG("1..25", expect: "too many '.'"),
      EG("1.2.3", expect: "too many '.'"),
    ]) {
      let expected = $0.expect

      XCTAssertThrowsError(
        try ValueParseStrategy().parse($0.input),
        "Expected '\(expected)'",
        file: $0.file,
        line: $0.line
      ) { error in
        let actual = error as! String
        XCTAssertEqual(actual, expected)
      }
    }
  }

  func test_LegalInchesWithOrWithoutDecimalPointsOrFractions() throws {
    try check([
      EG("3/4 in", expect: .inches(0.75), "numerator and denominator"),

      EG("1.25in", expect: .inches(1.25), "simple decimal"),

      EG("314.1/2in", expect: .inches(314.5), "explicit fraction"),
      EG("314.1/2⊕in", expect: .inches(314.5), "explicit fraction"),
      EG("314.1/2⊖in", expect: .inches(314.5), "explicit fraction"),
    ]) {
      EGAssertEqual(try ValueParseStrategy().parse($0.input), $0)
    }
  }

  func test_ErrorInchesWithOrWithoutDecimalPointsOrFractions() throws {
    try check([
      EG("/in", expect: "can't start with '/'"),
      EG("/31 in", expect: "can't start with '/'"),
      EG("3/in", expect: "missing denominator"),
      EG("314.1/in", expect: "missing denominator"),

      EG("1// in", expect: "simple fractions only (at most one '/'"),
      EG("1///in", expect: "simple fractions only (at most one '/'"),
      EG("314.1//in", expect: "simple fractions only (at most one '/'"),
      EG("3//4in", expect: "simple fractions only (at most one '/'"),
      EG("1/2/3in", expect: "simple fractions only (at most one '/'"),

      EG("1..25in", expect: "too many '.'"),
      EG("1.2.3in", expect: "too many '.'"),
    ]) {
      let expected = $0.expect
      XCTAssertThrowsError(
        try ValueParseStrategy().parse($0.input),
        "Expected '\(expected)'",
        file: $0.file,
        line: $0.line
      ) { error in
        let actual = error as! String
        XCTAssertEqual(actual, expected)
      }
    }
  }

  func test_LegalInchesWithMidDotInsteadOfDecimalPoint() throws {
    try check([
      EG("1•25in", expect: .inches(1.25), "simple decimal"),

      EG("314•1/2in", expect: .inches(314.5), "explicit fraction"),
      EG("314•11/8in", expect: .inches(315.375), "explicit fraction"),
      EG("314•8/16in", expect: .inches(314.5), "explicit fraction"),
    ]) {
      EGAssertEqual(try ValueParseStrategy().parse($0.input), $0)
    }
  }

  func test_ErrorInchesWithMidDotInsteadOfDecimalPoint() throws {
    try check([
      EG("314•1/in", expect: "missing denominator"),

      EG("314•1//in", expect: "simple fractions only (at most one '/'"),

      EG("1••25in", expect: "too many '.'"),
      EG("1•2•3in", expect: "too many '.'"),
    ]) {
      let expected = $0.expect
      XCTAssertThrowsError(
        try ValueParseStrategy().parse($0.input),
        "Expected '\(expected)'",
        file: $0.file,
        line: $0.line
      ) { error in
        let actual = error as! String
        XCTAssertEqual(actual, expected)
      }
    }
  }
}
