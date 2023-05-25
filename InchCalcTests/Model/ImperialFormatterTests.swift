@testable import InchCalc
import XCTest

final class ImperialFormatterTests: XCTestCase {
  func test_asInches() throws {
    XCTAssertEqual(ImperialFormatter.asInches(0), "0 in")
    XCTAssertEqual(ImperialFormatter.asInches(13), "13 in")
    XCTAssertEqual(ImperialFormatter.asInches(39), "39 in")
  }

  func test_asFeet() throws {
    XCTAssertEqual(ImperialFormatter.asFeetInches(0), "0 in")
    XCTAssertEqual(ImperialFormatter.asFeetInches(1), "1 in")
    XCTAssertEqual(ImperialFormatter.asFeetInches(12), "1 ft")
    XCTAssertEqual(ImperialFormatter.asFeetInches(13), "1 ft 1 in")
    XCTAssertEqual(ImperialFormatter.asFeetInches(39), "3 ft 3 in")
  }

  func test_asYardsFeetInches() throws {
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(0), "0 in")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(1), "1 in")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(12), "1 ft")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(13), "1 ft 1 in")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(36), "1 yd")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(39), "1 yd 3 in")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(60), "1 yd 2 ft")
    XCTAssertEqual(ImperialFormatter.asYardFeetInches(63), "1 yd 2 ft 3 in")
  }
}
