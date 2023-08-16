@testable import KiltCalc
import XCTest

struct ApronPleatSplit {
  let equalSplit: Double
  var pleatSteals: Double = 0.0

  var apron: Double {
    equalSplit - pleatSteals
  }

  var pleat: Double {
    equalSplit + pleatSteals
  }

  init(_ total: Double) {
    self.equalSplit = total / 2.0
  }

  mutating func givePleat(_ amount: Double) {
    pleatSteals = amount
  }
}

@MainActor
final class ApronPleatSplitTests: XCTestCase {
  func test_SplitStartsInHalf() throws {
    let split = ApronPleatSplit(40)
    XCTAssertEqual(split.apron, 20)
    XCTAssertEqual(split.pleat, 20)
  }

  func test_SplitMaintainsTotal() throws {
    var split = ApronPleatSplit(40)
    split.givePleat(0.5)
    XCTAssertEqual(split.apron, 19.5)
    XCTAssertEqual(split.pleat, 20.5)
  }
}
