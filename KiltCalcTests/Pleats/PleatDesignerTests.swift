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
    XCTAssertEqual(designer.settsPerPleat, 1.0)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.pleatCount, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_getPleatCountFails_WhenHipMeasureIsMissing() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = nil
    designer.sett = 6
    designer.pleatWidth = 2
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenSettIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 10
    designer.settsPerPleat = 2
    designer.sett = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenSettsPerPleatIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 10
    designer.sett = 5
    designer.settsPerPleat = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_WhenHipIsMissing_ThenOutputVariablesAreNil() {
    let designer = PleatDesigner()
    designer.settsPerPleat = 2
    designer.sett = 7
    designer.hipToHipMeasure = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_getPleatCountFails_WhenPleatWidthIsMissing() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.pleatWidth = nil
    XCTAssertEqual(designer.pleatCount, nil)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 6.0
    designer.pleatWidth = 2
    XCTAssertEqual(designer.pleatCount, 10)
  }

  func test_setPleatCountToNil_SetsTotalFabricToNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 5
    designer.pleatWidth = 2
    designer.pleatCount = nil

    XCTAssertEqual(designer.pleatCount, nil)
    XCTAssertEqual(designer.pleatWidth, 2)
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_setSettUpdates_PleatFabric_PleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 5

    XCTAssertEqual(designer.pleatFabric, 5.0)
    XCTAssertEqual(designer.pleatCount, 5)
    XCTAssertEqual(designer.pleatWidth, 8.0 / 5.0)
    XCTAssertEqual(designer.gap!, -0.1, accuracy: 0.000001)
  }

  func test_setSettWithSettsPerPleatNil_SetsNilFor_PleatWidth_Gap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.settsPerPleat = nil
    designer.sett = 5
    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettToNil_Makes_PleatFabric_PleatWidth_Gap_Nil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 5
    designer.sett = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 6
    designer.settsPerPleat = 1
    XCTAssertEqual(designer.pleatWidth, 2)
    XCTAssertEqual(designer.gap, 0)
    XCTAssertEqual(designer.pleatCount, 4)
  }

  func test_setSettsPerPleatUpdatesPleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 6
    designer.settsPerPleat = 1.5

    XCTAssertEqual(designer.pleatFabric, 9.0)
    XCTAssertEqual(designer.pleatWidth!, 2.666667, accuracy: 0.00001)
    XCTAssertEqual(designer.gap!, -0.5, accuracy: 0.000001)
  }

  func test_setSettsPerPleatToNil_Makes_PleatFabric_PleatWidth_Gap_Nil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 5
    designer.settsPerPleat = 2
    designer.settsPerPleat = nil

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setSettsPerPleat_WithSettNil_MakesPleatFabric_PleatWidth_Gap_BeNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = nil
    designer.settsPerPleat = 1

    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil )
  }

  func test_setPleatWidth_SetsGapAndHip() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 5
    designer.pleatWidth = 2

    XCTAssertEqual(designer.pleatWidth, 2)
    XCTAssertEqual(designer.gap, 0.5)
    XCTAssertEqual(designer.absoluteGap, 0.5)
    XCTAssertEqual(designer.gapLabel, "Gap")
    XCTAssertEqual(designer.pleatCount, 12)
    XCTAssertEqual(designer.hipToHipMeasure, 24)
  }

  func test_setPleatWidth_SetsGapOverlapAndPleatCount() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 6
    designer.pleatWidth = 1.75

    XCTAssertEqual(designer.gap, -0.375)
    XCTAssertEqual(designer.absoluteGap, 0.375)
    XCTAssertEqual(designer.gapLabel, "Overlap")
  }

  func test_setPleatCount_SetsPleatFabric_Hip_Gap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 5
    designer.pleatCount = 10

    XCTAssertEqual(designer.pleatFabric, 5)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth!, 1.666667, accuracy: 0.0001)
    XCTAssertEqual(designer.hipToHipMeasure!, 16.666667, accuracy: 0.0001)
    XCTAssertEqual(designer.gap, 0)
  }

  func test_setPleatWidthToNil_SetsGapToNil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 5
    designer.pleatCount = 10
    designer.pleatWidth = nil

    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
  }

  func test_setHip_UpdatesVariableOutput() {
    let designer = PleatDesigner()
    designer.sett = 6
    designer.settsPerPleat = 2
    designer.hipToHipMeasure = 20

    XCTAssertEqual(designer.pleatFabric, 12)
    XCTAssertEqual(designer.pleatWidth, 4)
    XCTAssertEqual(designer.gap, 0)
    XCTAssertEqual(designer.pleatCount, 5)
  }

  func test_WhenRequiredFieldsNotSet_totalFabricIsNil() {
    let designer = PleatDesigner()
    XCTAssertEqual(designer.totalFabric, nil)
  }

  func test_WhenRequiredFieldsPresent_totalFabricIsCalculated() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 6
    XCTAssertEqual(designer.totalFabric, 60)
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
      designer.hipToHipMeasure = 20
      designer.sett = 6
      designer.pleatWidth = $0.input
      EGAssertEqual(designer.message, $0)
    }
  }

  func test_HipErrorMessage() {
    check([
      eg(nil, expect: "Hip measure is required"),
      eg(20, expect: ""),
      eg(0, expect: "Hip measure must be positive"),
      eg(-20, expect: "Hip measure must be positive"),
    ]) {
      let designer = PleatDesigner()
      designer.hipToHipMeasure = $0.input
      EGAssertEqual(designer.hipError, $0)
    }
  }

  func test_SettErrorMessage() {
    check([
      eg(nil, expect: "Sett is required"),
      eg(20, expect: ""),
      eg(0, expect: "Sett must be positive"),
      eg(-20, expect: "Sett must be positive"),
    ]) {
      let designer = PleatDesigner()
      designer.sett = $0.input
      EGAssertEqual(designer.settError, $0)
    }
  }

  func test_SettsPerPleatErrorMessage() {
    check([
      eg(nil, expect: "Setts/pleat is required"),
      eg(20.0, expect: ""),
      eg(0, expect: "Setts/pleat must be positive"),
      eg(-20.0, expect: "Setts/pleat must be positive"),
    ]) {
      let designer = PleatDesigner()
      designer.settsPerPleat = $0.input
      EGAssertEqual(designer.settsPerPleatError, $0)
    }
  }

  func test_PleatWidthErrorMessage() {
    check([
      eg(nil, expect: ""),
      eg(20.0, expect: ""),
      eg(0, expect: "Pleat width must be positive"),
      eg(-20.0, expect: "Pleat width must be positive"),
    ]) {
      let designer = PleatDesigner()
      designer.pleatWidth = $0.input
      EGAssertEqual(designer.pleatWidthError, $0)
    }
  }

  func test_PleatWidthTooBigErrorMessage() {
    let designer = PleatDesigner()

    check([
      eg((nil, 10.0), expect: ""),
      eg((9.9, 10.0), expect: ""),
      eg((10.0, 10.0), expect: "Pleat width too large"),
    ]) {
      designer.hipToHipMeasure = 15
      designer.sett = $0.input.1
      designer.pleatWidth = $0.input.0
      EGAssertEqual(designer.pleatWidthError, $0)
    }
  }

  func test_PleatCountErrorMessage() {
    check([
      eg(nil, expect: ""),
      eg(20, expect: ""),
      eg(0, expect: "Pleat count must be positive"),
      eg(-20, expect: "Pleat count must be positive"),
    ]) {
      let designer = PleatDesigner()
      designer.pleatCount = $0.input
      EGAssertEqual(designer.pleatCountError, $0)
    }
  }
}
