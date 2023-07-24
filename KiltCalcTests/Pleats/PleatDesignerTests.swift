import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class PleatDesignerTests: XCTestCase {
  func test_initializesCorrectly() throws {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.idealHip, nil)
    XCTAssertEqual(designer.sett, nil)
    XCTAssertEqual(designer.settsPerPleat, .number(1.0))
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.pleatCount, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_getPleatCountFails_WhenHipMeasureIsMissing() {
    let designer = PleatDesigner()
    designer.idealHip = nil
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_PleatError_WhenHipMeasureIsError() {
    let designer = PleatDesigner()
    designer.idealHip = .error("missing denominator")
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenSettIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(10)
    designer.settsPerPleat = .number(2)
    designer.sett = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenSettsPerPleatIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(10)
    designer.sett = .inches(5)
    designer.settsPerPleat = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenHipIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.settsPerPleat = .number(2)
    designer.sett = .inches(7)
    designer.idealHip = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_getPleatCountFails_WhenPleatWidthIsMissing() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.pleatWidth = nil
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(6.0)
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, .number(10))
  }

  func test_setPleatCountToNil_SetsTotalFabricToNil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(5)
    designer.pleatWidth = .inches(2)
    designer.pleatCount = nil

    XCTAssertEqual(designer.pleatCount, nil)
    XCTAssertEqual(designer.pleatWidth, .inches(2))
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_setSettUpdates_PleatFabric_PleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = .inches(5)

    XCTAssertEqual(designer.pleatFabric, .inches(5.0))
    XCTAssertEqual(designer.pleatCount, .number(5))
    XCTAssertEqual(designer.pleatWidth, .inches(8.0 / 5.0))
    XCTAssertEqual(designer.gap!.asDouble, -0.1, accuracy: 0.000001)
  }

  func test_HipSetButSettError_SetsPleatFabricNil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = .error("some error)")
    XCTAssertEqual(designer.pleatFabric, nil)
  }

  func test_setSettWithSettsPerPleatNil_SetsNilFor_PleatWidth_Gap() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.settsPerPleat = nil
    designer.sett = .inches(5)
    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettToNil_Makes_PleatFabric_PleatWidth_Gap_Nil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = .inches(5)
    designer.sett = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1)
    XCTAssertEqual(designer.pleatWidth, .inches(2))
    XCTAssertEqual(designer.gap, .number(0))
    XCTAssertEqual(designer.pleatCount, .number(4))
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1.5)

    XCTAssertEqual(designer.pleatFabric, .inches(9.0))
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2.666667, accuracy: 0.00001)
    XCTAssertEqual(designer.gap!.asDouble, -0.5, accuracy: 0.000001)
  }

  func test_setSettsPerPleatToNil_Makes_PleatFabric_PleatWidth_Gap_Nil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = .inches(5)
    designer.settsPerPleat = .number(2)
    designer.settsPerPleat = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettsPerPleat_WithSettNil_MakesPleatFabric_PleatWidth_Gap_BeNil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(8)
    designer.sett = nil
    designer.settsPerPleat = .number(1)

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.gapRatio, 0.0)
  }

  func test_setPleatWidth_AdjustsPleatCountAndAdjustedHip() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(3)

    XCTAssertEqual(designer.pleatWidth, .inches(3))
    XCTAssertEqual(designer.gap, .inches(1.5))
    XCTAssertEqual(designer.absoluteGap, .inches(1.5))
    XCTAssertEqual(designer.gapRatio, 1.5 / 3)
    XCTAssertEqual(designer.gapLabel, "Gap")
    XCTAssertEqual(designer.pleatCount, .number(7))
    XCTAssertEqual(designer.idealHip, .inches(20))
    XCTAssertEqual(designer.adjustedHip, .inches(21))
  }

  func test_setPleatWidth_SetsGapOverlapAndPleatCount() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(1.75)

    XCTAssertEqual(designer.gap, .inches(-0.375))
    XCTAssertEqual(designer.absoluteGap, .inches(0.375))
    XCTAssertEqual(designer.gapLabel, "Overlap")
  }

  func test_setPleatCount_SetsPleatWidth_Gap() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(5)
    designer.pleatCount = .number(10)

    XCTAssertEqual(designer.pleatFabric, .inches(5))
    XCTAssertEqual(designer.pleatCount, .number(10))
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2)
    XCTAssertEqual(designer.idealHip!.asDouble, 20)
    XCTAssertEqual(designer.gap, .inches(0.5))
  }

  func test_setPleatCount_ForcedToInteger() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(21)
    designer.sett = .inches(5)
    designer.pleatCount = .number(10.5)

    XCTAssertEqual(designer.pleatCount, .number(11))
  }

  func test_WhenPleatWidthIsEmpty_setPleatCount_SetsPleatWidth() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(6)
    designer.pleatWidth = nil
    designer.pleatCount = .number(20)

    XCTAssertEqual(designer.pleatCount, .number(20))
    XCTAssertEqual(designer.pleatWidth, .inches(1))
    XCTAssertEqual(designer.gap, .inches(-1.5))
  }

  func test_setPleatCountWhenRequiredPleatTooLarge_SetsHip() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(6)
    designer.pleatCount = .number(2)

    XCTAssertEqual(designer.pleatCount, .number(2))
    XCTAssertEqual(designer.pleatWidth, .inches(6))
    XCTAssertEqual(designer.idealHip, .inches(20))
    XCTAssertEqual(designer.adjustedHip, .inches(12))
  }

  func test_setPleatWidthToNil_SetsGapToNil() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(5)
    designer.pleatCount = .number(10)
    designer.pleatWidth = nil

    XCTAssertEqual(designer.pleatCount, .number(10))
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setHip_UpdatesAdjustableOutput() {
    let designer = PleatDesigner()
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(2)
    designer.idealHip = .inches(20)

    XCTAssertEqual(designer.pleatFabric, .inches(12))
    XCTAssertEqual(designer.pleatWidth, .inches(4))
    XCTAssertEqual(designer.gap, .number(0))
    XCTAssertEqual(designer.pleatCount, .number(5))
  }

  func test_AdjustedHipWidth_IsPleatsTimesPleatWidth() {
    let designer = PleatDesigner()
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1)
    designer.idealHip = .inches(20)

    designer.pleatCount = .number(1)

    XCTAssertEqual(designer.pleatCount, .number(1))
    XCTAssertEqual(designer.pleatWidth, .inches(6))
    XCTAssertEqual(designer.adjustedHip, .inches(6))
  }

  func test_WhenPleatCountNil_AdjustedHipWidthIsNil() {
    let designer = PleatDesigner()
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1)
    designer.idealHip = .inches(20)

    designer.pleatCount = nil

    XCTAssertEqual(designer.adjustedHip, nil)
  }

  func test_WhenPleatWidthNil_AdjustedHipWidthIsNil() {
    let designer = PleatDesigner()
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1)
    designer.idealHip = .inches(20)

    designer.pleatWidth = nil

    XCTAssertEqual(designer.adjustedHip, nil)
  }

  func test_WhenRequiredFieldsNotSet_totalFabricIsNil() {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_WhenRequiredFieldsPresent_totalFabricIsCalculated() {
    let designer = PleatDesigner()
    designer.idealHip = .inches(20)
    designer.sett = .inches(6)
    XCTAssertEqual(designer.totalFabric, .inches(60))
  }

  func test_Message_None() {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.pleatType, "Type Can't Be Determined")
  }

  func test_Message() {
    check([
      eg(2, expect: "Box Pleat"),
      eg(2.1, expect: "Box Pleat with Gap"),
      eg(1.7, expect: "Box Pleat with Overlap"),
      eg(1.5, expect: "Military Box Pleat"),
      eg(3, expect: "Box Pleat with Too-Large Gap"),
    ]) {
      let designer = PleatDesigner()
      designer.idealHip = .inches(20)
      designer.sett = .inches(6)
      designer.pleatWidth = .inches($0.input)
      EGAssertEqual(designer.pleatType, $0)
    }
  }
}
