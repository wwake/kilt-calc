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

  func test_setSettUpdatesPleatWidth_Gap_PleatCount_WithGap() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 5
    XCTAssertEqual(designer.pleatWidth, 5 / 3)
    XCTAssertEqual(designer.gap!, 0, accuracy: 0.000001)
    XCTAssertEqual(designer.pleatCount, 3 * 8 / 5)
  }

  func test_setSettToNil_MakesPleatWidth_Gap_PleatCount_Nil() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 8
    designer.sett = 5
    designer.sett = nil

    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.gap, nil)
    XCTAssertEqual(designer.pleatCount, nil)
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
    XCTAssertEqual(designer.pleatWidth, 3.0)
    XCTAssertEqual(designer.gap!, 0, accuracy: 0.000001)
    XCTAssertEqual(designer.pleatCount, 8 / 3)
  }

  func test_setPleatWidth_SetsGapAndPleatCount() {
    let designer = PleatDesigner()
    designer.hipToHipMeasure = 20
    designer.sett = 5
    designer.pleatWidth = 2
    XCTAssertEqual(designer.gap, 0.5)
    XCTAssertEqual(designer.pleatCount, 10)
  }
}
