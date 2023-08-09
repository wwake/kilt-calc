import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class BoxPleatDesignerTests: XCTestCase {
  private let designer = PleatDesigner(PleatDesigner.boxPleat)

  private func checkValueEquality(_ actual: Value?, _ expected: Value?, accuracy: Double = 0.0) {
    if actual == nil && expected == nil { return }
    XCTAssertEqual(actual!.asDouble, expected!.asDouble, accuracy: accuracy)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, 10)
  }

  func test_setPleatFabric_Updates_PleatWidth_Gap_PleatCount() {
    designer.idealHip = .inches(8)
    designer.pleatFabric = 5

    XCTAssertEqual(designer.pleatFabric, 5.0)
    XCTAssertEqual(designer.pleatCount, 5)
    checkValueEquality(designer.pleatWidth, .inches(8.0 / 5.0))
    XCTAssertEqual(designer.gap!.size, -0.1, accuracy: 0.000001)
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount() {
    designer.idealHip = .inches(8)
    designer.pleatFabric = 6

    XCTAssertEqual(designer.pleatWidth, .number(2))
    XCTAssertEqual(designer.gap!.size, 0)
    XCTAssertEqual(designer.pleatCount, 4)
  }

  func test_setPleatFabric_UpdatesPleatWidth_Gap_PleatCount_WithGap() {
    designer.idealHip = .inches(8)
    designer.pleatFabric = 9

    XCTAssertEqual(designer.pleatFabric, 9.0)
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2.666667, accuracy: 0.00001)
    XCTAssertEqual(designer.gap!.size, -0.5, accuracy: 0.000001)
  }

  func test_setSettsPerPleat_WithSettNil_MakesPleatFabric_PleatWidth_Gap_BeNil() {
    designer.idealHip = .inches(8)
    designer.pleatFabric = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setPleatWidth_AdjustsPleatCountAndAdjustedHip() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(3)

    XCTAssertEqual(designer.pleatWidth, .number(3))
    XCTAssertEqual(designer.gap!.size, 1.5)
    XCTAssertEqual(designer.gap!.ratio, 1.5 / 3)
    XCTAssertEqual(designer.gap!.label, "Gap: 1•4/8 in")
    XCTAssertEqual(designer.pleatCount, 7)
    XCTAssertEqual(designer.idealHip, .inches(20))
    XCTAssertEqual(designer.adjustedHip, .number(21))
  }

  func test_setPleatWidth_SetsGapOverlapAndPleatCount() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(1.75)

    XCTAssertEqual(designer.gap!.size, -0.375)
    XCTAssertEqual(designer.gap!.label, "Overlap: 3/8 in")
  }

  func test_setPleatCount_SetsPleatWidth_Gap() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 5
    designer.pleatCount = 10

    XCTAssertEqual(designer.pleatFabric, 5)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2)
    XCTAssertEqual(designer.idealHip!.asDouble, 20)
    XCTAssertEqual(designer.gap!.size, 0.5)
  }

  func test_WhenPleatWidthIsEmpty_setPleatCount_SetsPleatWidth() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = nil
    designer.pleatCount = 20

    XCTAssertEqual(designer.pleatCount, 20)
    XCTAssertEqual(designer.pleatWidth, .number(1))
    XCTAssertEqual(designer.gap!.size, -1.5)
  }

  func test_setPleatCountWhenRequiredPleatTooLarge_SetsHip() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatCount = 2

    XCTAssertEqual(designer.pleatCount, 2)
    XCTAssertEqual(designer.pleatWidth, .number(6))
    XCTAssertEqual(designer.idealHip, .inches(20))
    XCTAssertEqual(designer.adjustedHip, .number(12))
  }

  func test_setPleatWidthToNil_SetsGapToNil() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 5
    designer.pleatCount = 10
    designer.pleatWidth = nil

    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setHip_UpdatesAdjustableOutput() {
    designer.pleatFabric = 12.0
    designer.idealHip = .inches(20)

    XCTAssertEqual(designer.pleatFabric, 12)
    XCTAssertEqual(designer.pleatWidth, .number(4))
    XCTAssertEqual(designer.gap!.size, 0)
    XCTAssertEqual(designer.pleatCount, 5)
  }

  func test_AdjustedHipWidth_IsPleatsTimesPleatWidth() {
    designer.pleatFabric = 6
    designer.idealHip = .inches(20)

    designer.pleatCount = 1

    XCTAssertEqual(designer.pleatCount, 1)
    XCTAssertEqual(designer.pleatWidth, .number(6))
    XCTAssertEqual(designer.adjustedHip, .number(6))
  }

  func test_WhenPleatWidthNil_AdjustedHipWidthIsNil() {
    designer.pleatFabric = 6
    designer.idealHip = .inches(20)

    designer.pleatWidth = nil

    XCTAssertEqual(designer.adjustedHip, nil)
  }

  func test_WhenRequiredFieldsNotSet_totalFabricIsNil() {
    XCTAssertEqual(designer.totalFabric, "?")
  }

  func test_WhenRequiredFieldsPresent_totalFabricIsCalculated() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6

    XCTAssertEqual(designer.totalFabric, "60 in")
  }
}
