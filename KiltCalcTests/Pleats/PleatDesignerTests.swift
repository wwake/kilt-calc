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

  func test_whenHipIsLessThanOne_NeedsRequiredValuesIsTrue() {
    designer.pleatFabric = 10
    designer.idealHip = Value.inches(0.99)

    XCTAssertEqual(designer.needsRequiredValues, true)
  }

  func test_whenHipIsBigEnough_NeedsRequiredValuesIsFalse() {
    designer.pleatFabric = 10
    designer.idealHip = Value.inches(1)

    XCTAssertEqual(designer.needsRequiredValues, false)
  }

  func test_depthIsHalfOfFabricLessPleatWidth() {
    designer.idealHip = Value.inches(20)
    designer.pleatFabric = 10
    designer.pleatWidth = .inches(4)
    XCTAssertEqual(designer.depth, 3)
  }

  func test_depthIsNil_WhenFabricNil() {
    designer.idealHip = Value.inches(20)
    designer.pleatFabric = nil
    designer.pleatWidth = .inches(4)
    XCTAssertEqual(designer.depth, nil)
  }

  func test_depthIsNil_WhenPleatWidthNil() {
    designer.idealHip = Value.inches(20)
    designer.pleatFabric = 8
    designer.pleatWidth = nil
    XCTAssertEqual(designer.depth, nil)
  }
}
