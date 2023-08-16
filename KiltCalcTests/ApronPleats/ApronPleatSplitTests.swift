@testable import KiltCalc
import XCTest

struct ApronPleatSplit {
  let total: Double
  var apron: Double
  var pleat: Double
  var pleatSteals: Double = 0.0

  init(_ total: Double) {
    self.total = total
    self.apron = total / 2.0
    self.pleat = total / 2.0
  }

  mutating func givePleat(_ amount: Double) {
    pleatSteals = amount
    apron -= pleatSteals
    pleat += pleatSteals
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
