@testable import KiltCalc
import XCTest

@MainActor
final class KnifePleatDesignerTests: XCTestCase {
  func test_initializesCorrectly() throws {
    let designer = KnifePleatDesigner()
    XCTAssertEqual(designer.needsRequiredValues, true)

    XCTAssertEqual(designer.idealHip, nil)
    XCTAssertEqual(designer.adjustedHip, nil)
    XCTAssertEqual(designer.hipWasAdjusted, false)

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_unusedFieldsHaveTrivialDefault() throws {
    let designer = KnifePleatDesigner()
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.absoluteGap, nil)
    XCTAssertEqual(designer.gapRatio, 0.0)
    XCTAssertEqual(designer.gapLabel, "")
  }

  func test_WhenPleatFabricIsMissing_ThenOutputVariablesAreNil() {
    let designer = KnifePleatDesigner()
    designer.idealHip = .inches(10)
    designer.pleatFabric = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_WhenHipIsMissing_ThenOutputVariablesAreNil() {
    let designer = KnifePleatDesigner()
    designer.pleatFabric = 7
    designer.idealHip = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    let designer = KnifePleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(1)
    XCTAssertEqual(designer.pleatCount, 20)
  }

  func test_getPleatCount_WhenPredecessorValuesChangedToNil() {
    let designer = KnifePleatDesigner()
    designer.idealHip = nil
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(1)
    XCTAssertEqual(designer.pleatCount, 10)
  }

  func test_getPleatCount_WhenPleatWidthIsNil() {
    let designer = KnifePleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = nil
    XCTAssertEqual(designer.pleatCount, 10)
  }

  func test_getPleatCount_WhenPleatWidthIs0() {
    let designer = KnifePleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(0)
    XCTAssertEqual(designer.pleatCount, 10)
  }
}
