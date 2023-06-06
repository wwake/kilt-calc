import EGTest
@testable import InchCalc
import XCTest

final class ImperialFormatterTests: XCTestCase {
  func test_asInches() throws {
    check([
      EG(0, expect: "0 in"),
      EG(13, expect: "13 in"),
      EG(39, expect: "39 in"),
    ]) {
      XCTAssertEqual(ImperialFormatter.asInches(NumberFormatter(), $0.input), $0.expect, file: $0.file, line: $0.line)
    }
  }

  func test_asYardsFeetInches() throws {
    check([
      EG(0, expect: "0 in"),
      EG(1, expect: "1 in"),
      EG(12, expect: "1 ft"),
      EG(13, expect: "1 ft 1 in"),
      EG(36, expect: "1 yd"),
      EG(39, expect: "1 yd 3 in"),
      EG(60, expect: "1 yd 2 ft"),
      EG(63, expect: "1 yd 2 ft 3 in"),
    ]) {
      XCTAssertEqual(
        ImperialFormatter.asYardFeetInches(NumberFormatter(), $0.input),
        $0.expect,
        file: $0.file,
        line: $0.line
      )
    }
  }

  func test_negativeUnits() throws {
    check([
      EG(0, expect: "0 in"),
      EG(-1, expect: "-1 in"),
      EG(-12, expect: "-1 ft"),
      EG(-13, expect: "-1 ft -1 in"),
      EG(-36, expect: "-1 yd"),
      EG(-37, expect: "-1 yd -1 in"),
      EG(-48, expect: "-1 yd -1 ft"),
      EG(-50, expect: "-1 yd -1 ft -2 in"),
    ]) {
      XCTAssertEqual(
        ImperialFormatter.asYardFeetInches(NumberFormatter(), $0.input),
        $0.expect,
        file: $0.file,
        line: $0.line
      )
    }
  }
}
