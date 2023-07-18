import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class PleatDesignerTests: XCTestCase {
  func test_initializesCorrectly() throws {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.notes, "")
    XCTAssertEqual(designer.hipToHipMeasure, nil)
    XCTAssertEqual(designer.sett, nil)
    XCTAssertEqual(designer.settsPerPleat, .number(1.0))
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.pleatCount, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_getPleatCountFails_WhenHipMeasureIsMissing() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = nil
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_PleatError_WhenHipMeasureIsError() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .error("missing denominator")
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenSettIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(10)
    designer.settsPerPleat = .number(2)
    designer.sett = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenSettsPerPleatIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(10)
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
    designer.hipToHipMeasure = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_getPleatCountFails_WhenPleatWidthIsMissing() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.pleatWidth = nil
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(6.0)
    designer.pleatWidth = .inches(2)
    XCTAssertEqual(designer.pleatCount, .number(10))
  }

  func test_setPleatCountToNil_SetsTotalFabricToNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(5)
    designer.pleatWidth = .inches(2)
    designer.pleatCount = nil

    XCTAssertEqual(designer.pleatCount, nil)
    XCTAssertEqual(designer.pleatWidth, .inches(2))
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_setSettUpdates_PleatFabric_PleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = .inches(5)

    XCTAssertEqual(designer.pleatFabric, .inches(5.0))
    XCTAssertEqual(designer.pleatCount, .number(5))
    XCTAssertEqual(designer.pleatWidth, .inches(8.0 / 5.0))
    XCTAssertEqual(designer.gap!.asDouble, -0.1, accuracy: 0.000001)
  }

  func test_HipSetButSettError_SetsPleatFabricNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = .error("some error)")
    XCTAssertEqual(designer.pleatFabric, nil)
  }

  func test_setSettWithSettsPerPleatNil_SetsNilFor_PleatWidth_Gap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.settsPerPleat = nil
    designer.sett = .inches(5)
    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettToNil_Makes_PleatFabric_PleatWidth_Gap_Nil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = .inches(5)
    designer.sett = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1)
    XCTAssertEqual(designer.pleatWidth, .inches(2))
    XCTAssertEqual(designer.gap, .number(0))
    XCTAssertEqual(designer.pleatCount, .number(4))
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(1.5)

    XCTAssertEqual(designer.pleatFabric, .inches(9.0))
    XCTAssertEqual(designer.pleatWidth!.asDouble, 2.666667, accuracy: 0.00001)
    XCTAssertEqual(designer.gap!.asDouble, -0.5, accuracy: 0.000001)
  }

  func test_setSettsPerPleatToNil_Makes_PleatFabric_PleatWidth_Gap_Nil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = .inches(5)
    designer.settsPerPleat = .number(2)
    designer.settsPerPleat = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettsPerPleat_WithSettNil_MakesPleatFabric_PleatWidth_Gap_BeNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(8)
    designer.sett = nil
    designer.settsPerPleat = .number(1)

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil )
  }

  func test_setPleatWidth_SetsGapAndHip() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(5)
    designer.pleatWidth = .inches(2)

    XCTAssertEqual(designer.pleatWidth, .inches(2))
    XCTAssertEqual(designer.gap, .inches(0.5))
    XCTAssertEqual(designer.absoluteGap, .inches(0.5))
    XCTAssertEqual(designer.gapLabel, "Gap")
    XCTAssertEqual(designer.pleatCount, .number(12))
    XCTAssertEqual(designer.hipToHipMeasure, .inches(24))
  }

  func test_setPleatWidth_SetsGapOverlapAndPleatCount() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(6)
    designer.pleatWidth = .inches(1.75)

    XCTAssertEqual(designer.gap, .inches(-0.375))
    XCTAssertEqual(designer.absoluteGap, .inches(0.375))
    XCTAssertEqual(designer.gapLabel, "Overlap")
  }

  func test_setPleatCount_SetsPleatFabric_Hip_Gap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(5)
    designer.pleatCount = .number(10)

    XCTAssertEqual(designer.pleatFabric, .inches(5))
    XCTAssertEqual(designer.pleatCount, .number(10))
    XCTAssertEqual(designer.pleatWidth!.asDouble, 1.666667, accuracy: 0.0001)
    XCTAssertEqual(designer.hipToHipMeasure!.asDouble, 16.666667, accuracy: 0.0001)
    XCTAssertEqual(designer.gap, .number(0))
  }

  func test_setPleatCount_ForcedToInteger() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(21)
    designer.sett = .inches(5)
    designer.pleatCount = .number(10.5)

    XCTAssertEqual(designer.pleatCount, .number(11))
  }

  func test_setPleatWidthToNil_SetsGapToNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(5)
    designer.pleatCount = .number(10)
    designer.pleatWidth = nil

    XCTAssertEqual(designer.pleatCount, .number(10))
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setHip_UpdatesVariableOutput() {
    let designer = PleatDesigner()
    designer.sett = .inches(6)
    designer.settsPerPleat = .number(2)
    designer.hipToHipMeasure = .inches(20)

    XCTAssertEqual(designer.pleatFabric, .inches(12))
    XCTAssertEqual(designer.pleatWidth, .inches(4))
    XCTAssertEqual(designer.gap, .number(0))
    XCTAssertEqual(designer.pleatCount, .number(5))
  }

  func test_WhenRequiredFieldsNotSet_totalFabricIsNil() {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_WhenRequiredFieldsPresent_totalFabricIsCalculated() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = .inches(20)
    designer.sett = .inches(6)
    XCTAssertEqual(designer.totalFabric, .inches(60))
  }

  func test_Message_None() {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.message, "Type Can't Be Determined")
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
      designer.hipToHipMeasure = .inches(20)
      designer.sett = .inches(6)
      designer.pleatWidth = .inches($0.input)
      EGAssertEqual(designer.message, $0)
    }
  }

  func test_PleatWidthNil_HasNoErrorMessage() {
    let designer = PleatDesigner()
    designer.pleatWidth = nil
    XCTAssertEqual(designer.pleatWidthError, "")
  }

  func test_PleatWidthErrorMessage() {
    check([
      eg(20.0, expect: ""),
      eg(0, expect: "Must be positive"),
      eg(-20.0, expect: "Must be positive"),
    ]) {
      let designer = PleatDesigner()
      designer.pleatWidth = .inches($0.input)
      EGAssertEqual(designer.pleatWidthError, $0)
    }
  }

  func test_PleatWidthTooBigErrorMessage() {
    let designer = PleatDesigner()

    check([
      eg((9.9, 10.0), expect: ""),
      eg((10.0, 10.0), expect: "Value too large"),
    ]) {
      designer.hipToHipMeasure = .inches(15)
      designer.sett = .inches($0.input.1)
      designer.pleatWidth = .inches($0.input.0)
      EGAssertEqual(designer.pleatWidthError, $0)
    }
  }
}
