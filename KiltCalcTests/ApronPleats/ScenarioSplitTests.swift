@testable import KiltCalc
import XCTest

@MainActor
final class ScenarioSplitTests: XCTestCase {
  func testWaistAndHipBothSplitInitially() {
    let scenario = ScenarioSplit([.waist: 30, .hips: 34])
    XCTAssertEqual(scenario[.waist]!.apron, 15.0)
    XCTAssertEqual(scenario[.waist]!.pleat, 15.0)
    XCTAssertEqual(scenario[.hips]!.apron, 17.0)
    XCTAssertEqual(scenario[.hips]!.pleat, 17.0)
  }

  func testAdjustWaistLeavesHipsAlone() {
    var scenario = ScenarioSplit([.waist: 30, .hips: 34])
    scenario.givePleat(.waist, 2.5)
    XCTAssertEqual(scenario[.waist]!.apron, 12.5)
    XCTAssertEqual(scenario[.waist]!.pleat, 17.5)
    XCTAssertEqual(scenario[.hips]!.apron, 17.0)
    XCTAssertEqual(scenario[.hips]!.pleat, 17.0)
  }

  func testAdjustHipsLeavesWaistAlone() {
    var scenario = ScenarioSplit([.waist: 30, .hips: 34])
    scenario.givePleat(.hips, 1)
    XCTAssertEqual(scenario[.waist]!.apron, 15.0)
    XCTAssertEqual(scenario[.waist]!.pleat, 15.0)
    XCTAssertEqual(scenario[.hips]!.apron, 16.0)
    XCTAssertEqual(scenario[.hips]!.pleat, 18.0)
  }
}
