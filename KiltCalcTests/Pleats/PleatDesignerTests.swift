@testable import KiltCalc
import XCTest

@MainActor
final class PleatDesignerTests: XCTestCase {
  private let designer = PleatDesigner(PleatDesigner.boxPleat)

  func test_initializesCorrectly() throws {
    XCTAssertEqual(designer.needsRequiredValues, true)

    XCTAssertEqual(designer.idealHip, nil)
    XCTAssertEqual(designer.adjustedHip, nil)
    XCTAssertEqual(designer.hipWasAdjusted, false)

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.totalFabric, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_WhenPleatFabricIsMissing_ThenOutputVariablesAreNil() {
    designer.idealHip = .inches(10)
    designer.pleatFabric = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }
  func test_WhenHipIsMissing_ThenOutputVariablesAreNil() {
    designer.pleatFabric = 7
    designer.idealHip = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }
}
