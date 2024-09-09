@testable import KiltCalc
import XCTest

final class ScenariosTests: XCTestCase {
  func test_append() throws {
    let scenarios = Scenarios()

    scenarios.append(KiltMeasures(actualWaist: 40, actualHips: 42))

    XCTAssertEqual(scenarios.scenarios.first![.waist]!.apron, 20.0)
    XCTAssertEqual(scenarios.scenarios.first![.hips]!.apron, 21.0)
  }

  func test_clearResetsScenarios() throws {
    let scenarios = Scenarios()
    scenarios.append(KiltMeasures(actualWaist: 40, actualHips: 42))

    scenarios.clear()

    XCTAssertEqual(scenarios.scenarios.count, 0)
  }

  func test_appendIncompleteMeasures_IsIgnored() {
    let scenarios = Scenarios()
    scenarios.append(KiltMeasures(actualWaist: nil, actualHips: 42))
    XCTAssertEqual(scenarios.scenarios.count, 0)
  }

  func test_changeScenariosClears_EvenIfNewScenariosNotAllowed() {
    let scenarios = Scenarios()
    scenarios.append(KiltMeasures(actualWaist: 40, actualHips: 42))
    scenarios.changeScenarios(false, KiltMeasures(actualWaist: nil, actualHips: 42))
    XCTAssertEqual(scenarios.scenarios.count, 0)
  }

  func test_changeScenariosAddsNewScenario_IfNewScenarioIsAllowed() {
    let scenarios = Scenarios()
    scenarios.append(KiltMeasures(actualWaist: 30, actualHips: 42))
    scenarios.changeScenarios(true, KiltMeasures(actualWaist: 44, actualHips: 42))
    XCTAssertEqual(scenarios.scenarios.count, 1)
    XCTAssertEqual(scenarios.scenarios.first![.waist]!.apron, 22.0)
  }
}
