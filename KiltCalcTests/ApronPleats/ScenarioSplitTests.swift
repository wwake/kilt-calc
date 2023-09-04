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
    scenario.givePleat(.waist, -2.5)
    XCTAssertEqual(scenario[.waist]!.apron, 12.5)
    XCTAssertEqual(scenario[.waist]!.pleat, 17.5)
    XCTAssertEqual(scenario[.hips]!.apron, 17.0)
    XCTAssertEqual(scenario[.hips]!.pleat, 17.0)
  }

  func testAdjustHipsLeavesWaistAlone() {
    var scenario = ScenarioSplit([.waist: 30, .hips: 34])
    scenario.givePleat(.hips, -1)
    XCTAssertEqual(scenario[.waist]!.apron, 15.0)
    XCTAssertEqual(scenario[.waist]!.pleat, 15.0)
    XCTAssertEqual(scenario[.hips]!.apron, 16.0)
    XCTAssertEqual(scenario[.hips]!.pleat, 18.0)
  }

  func testWarnIfApronBiggerThanPleatAtWaist() {
    var scenario = ScenarioSplit([.waist: 30, .hips: 34])
    scenario.givePleat(.waist, 0.25)
    scenario.givePleat(.hips, 0.5)
    XCTAssertEqual(scenario.warnings, [
      "Pleats should be bigger than apron at waist.",
      "Pleats should be bigger than apron at hips.",
    ])
  }

  func testWarnIfApronAtHipSmallerThanApronAtWaist() {
    let scenario = ScenarioSplit([.waist: 32, .hips: 30])
    XCTAssertEqual(scenario.warnings, [
      "Apron at hips should be at least as big as apron at waist.",
    ])
  }

  func testDontWarnIfApronAtHipEqualsApronAtWaist() {
    let scenario = ScenarioSplit([.waist: 32, .hips: 32])
    XCTAssertEqual(scenario.warnings, [])
  }

  func testDontWarnIfApronAtHipBiggerThanApronAtWaist() {
    let scenario = ScenarioSplit([.waist: 28, .hips: 32])
    XCTAssertEqual(scenario.warnings, [])
  }

  func testWarnIfTooMuchDifferenceBetweenWaistAndHipAtApron() {
    let scenario = ScenarioSplit([.waist: 24, .hips: 32.1])
    XCTAssertEqual(scenario.warnings, [
      "Prefer at most 4” difference between waist and hip in the apron.",
    ])
  }

  func testDontWarnIfAtMaxDifferenceBetweenWaistAndHipAtApron() {
    let scenario = ScenarioSplit([.waist: 24, .hips: 32])
    XCTAssertEqual(scenario.warnings, [])
  }

  func testDontWarnIfDifferenceBetweenWaistAndHipAtApronIsSmallEnough() {
    let scenario = ScenarioSplit([.waist: 24, .hips: 31])
    XCTAssertEqual(scenario.warnings, [])
  }
}
