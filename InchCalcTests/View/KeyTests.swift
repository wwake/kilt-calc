@testable import InchCalc
import XCTest

final class KeyTests: XCTestCase {
  private var savedString: String = ""

  private func helper(_ string: String) {
    savedString = string
  }

  func test_KeyTriggersItsActionWithItsName() throws {
    let key = Key("x", helper)
    savedString = ""
    key.press()
    XCTAssertEqual(savedString, "x")
  }
}
