@testable import KiltCalc
import XCTest

final class ApronPleatSplitTests: XCTestCase {
  func test_SplitStartsInHalf() throws {
    let split = ApronPleatSplit(40)
    XCTAssertEqual(split.apron, 20)
    XCTAssertEqual(split.pleat, 20)
  }

  func test_SplitMaintainsTotal() throws {
    var split = ApronPleatSplit(40)
    split.giveApron(-0.5)
    XCTAssertEqual(split.apron, 19.5)
    XCTAssertEqual(split.pleat, 20.5)
  }
}
