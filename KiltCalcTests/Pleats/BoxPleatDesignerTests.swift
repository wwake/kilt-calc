import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class BoxPleatDesignerTests: XCTestCase {
  private func checkValueEquality(_ actual: Value?, _ expected: Value?, accuracy: Double = 0.0) {
    if actual == nil && expected == nil { return }
    XCTAssertEqual(actual!.asDouble, expected!.asDouble, accuracy: accuracy)
  }

  func test_initializesCorrectly() throws {
    let designer = BoxPleatDesigner()
    XCTAssertEqual(designer.idealHip, nil)
    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_WhenPleatFabricIsMissing_ThenOutputVariablesAreNil() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(10)
    designer.pleatFabric = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_WhenHipIsMissing_ThenOutputVariablesAreNil() {
    let designer = BoxPleatDesigner()
    designer.pleatFabric = 7
    designer.idealHip = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, 10)
  }

  func test_setSettUpdates_PleatFabric_PleatWidth_Gap_PleatCount_WithGap() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(8)
    designer.pleatFabric = 5

    XCTAssertEqual(designer.pleatFabric, 5.0)
    XCTAssertEqual(designer.pleatCount, 5)
    checkValueEquality(designer.pleatWidth, .inches(8.0 / 5.0))
    XCTAssertEqual(designer.gap!, -0.1, accuracy: 0.000001)
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(8)
    designer.pleatFabric = 6

    XCTAssertEqual(designer.pleatWidth, .number(2))
    XCTAssertEqual(designer.gap, 0)
    XCTAssertEqual(designer.pleatCount, 4)
  }

  func test_setPleatFabric_UpdatesPleatWidth_Gap_PleatCount_WithGap() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(8)
    designer.pleatFabric = 9

    XCTAssertEqual(designer.pleatFabric, 9.0)
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2.666667, accuracy: 0.00001)
    XCTAssertEqual(designer.gap!, -0.5, accuracy: 0.000001)
  }

  func test_setSettsPerPleat_WithSettNil_MakesPleatFabric_PleatWidth_Gap_BeNil() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(8)
    designer.pleatFabric = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.gapRatio, 0.0)
  }

  func test_setPleatWidth_AdjustsPleatCountAndAdjustedHip() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(3)

    XCTAssertEqual(designer.pleatWidth, .number(3))
    XCTAssertEqual(designer.gap, 1.5)
    XCTAssertEqual(designer.absoluteGap, 1.5)
    XCTAssertEqual(designer.gapRatio, 1.5 / 3)
    XCTAssertEqual(designer.gapLabel, "Gap")
    XCTAssertEqual(designer.pleatCount, 7)
    XCTAssertEqual(designer.idealHip, .inches(20))
    XCTAssertEqual(designer.adjustedHip, .number(21))
  }

  func test_setPleatWidth_SetsGapOverlapAndPleatCount() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(1.75)

    XCTAssertEqual(designer.gap, -0.375)
    XCTAssertEqual(designer.absoluteGap, 0.375)
    XCTAssertEqual(designer.gapLabel, "Overlap")
  }

  func test_setPleatCount_SetsPleatWidth_Gap() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 5
    designer.pleatCount = 10

    XCTAssertEqual(designer.pleatFabric, 5)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2)
    XCTAssertEqual(designer.idealHip!.asDouble, 20)
    XCTAssertEqual(designer.gap, 0.5)
  }

  func test_WhenPleatWidthIsEmpty_setPleatCount_SetsPleatWidth() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = nil
    designer.pleatCount = 20

    XCTAssertEqual(designer.pleatCount, 20)
    XCTAssertEqual(designer.pleatWidth, .number(1))
    XCTAssertEqual(designer.gap, -1.5)
  }

  func test_setPleatCountWhenRequiredPleatTooLarge_SetsHip() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatCount = 2

    XCTAssertEqual(designer.pleatCount, 2)
    XCTAssertEqual(designer.pleatWidth, .number(6))
    XCTAssertEqual(designer.idealHip, .inches(20))
    XCTAssertEqual(designer.adjustedHip, .number(12))
  }

  func test_setPleatWidthToNil_SetsGapToNil() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 5
    designer.pleatCount = 10
    designer.pleatWidth = nil

    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setHip_UpdatesAdjustableOutput() {
    let designer = BoxPleatDesigner()
    designer.pleatFabric = 12.0
    designer.idealHip = .inches(20)

    XCTAssertEqual(designer.pleatFabric, 12)
    XCTAssertEqual(designer.pleatWidth, .number(4))
    XCTAssertEqual(designer.gap, 0)
    XCTAssertEqual(designer.pleatCount, 5)
  }

  func test_AdjustedHipWidth_IsPleatsTimesPleatWidth() {
    let designer = BoxPleatDesigner()
    designer.pleatFabric = 6
    designer.idealHip = .inches(20)

    designer.pleatCount = 1

    XCTAssertEqual(designer.pleatCount, 1)
    XCTAssertEqual(designer.pleatWidth, .number(6))
    XCTAssertEqual(designer.adjustedHip, .number(6))
  }

  func test_WhenPleatWidthNil_AdjustedHipWidthIsNil() {
    let designer = BoxPleatDesigner()
    designer.pleatFabric = 6
    designer.idealHip = .inches(20)

    designer.pleatWidth = nil

    XCTAssertEqual(designer.adjustedHip, nil)
  }

  func test_WhenRequiredFieldsNotSet_totalFabricIsNil() {
    let designer = BoxPleatDesigner()
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_WhenRequiredFieldsPresent_totalFabricIsCalculated() {
    let designer = BoxPleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6

    XCTAssertEqual(designer.totalFabric, 60)
  }
}