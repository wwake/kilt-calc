@testable import KiltCalc
import XCTest

struct ScenarioSplit {
  var waist: ApronPleatSplit
  var hips: ApronPleatSplit

  init(waist: Double, hips: Double) {
    self.waist = ApronPleatSplit(waist)
    self.hips = ApronPleatSplit(hips)
  }
}

@MainActor
final class ScenarioSplitTests: XCTestCase {
  func testWaistAndHipBothSplitInitially() {
    let scenario = ScenarioSplit(waist: 30, hips: 34)
    XCTAssertEqual(scenario.waist.apron, 15.0)
    XCTAssertEqual(scenario.waist.pleat, 15.0)
    XCTAssertEqual(scenario.hips.apron, 17.0)
    XCTAssertEqual(scenario.hips.pleat, 17.0)
  }

  func testAdjustWaistLeavesHipsAlone() {
    var scenario = ScenarioSplit(waist: 30, hips: 34)
    scenario.waist.givePleat(2.5)
    XCTAssertEqual(scenario.waist.apron, 12.5)
    XCTAssertEqual(scenario.waist.pleat, 17.5)
    XCTAssertEqual(scenario.hips.apron, 17.0)
    XCTAssertEqual(scenario.hips.pleat, 17.0)
  }

  func testAdjustHipsLeavesWaistAlone() {
    var scenario = ScenarioSplit(waist: 30, hips: 34)
    scenario.hips.givePleat(1)
    XCTAssertEqual(scenario.waist.apron, 15.0)
    XCTAssertEqual(scenario.waist.pleat, 15.0)
    XCTAssertEqual(scenario.hips.apron, 16.0)
    XCTAssertEqual(scenario.hips.pleat, 18.0)
  }
}
