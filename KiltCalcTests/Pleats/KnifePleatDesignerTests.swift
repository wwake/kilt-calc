@testable import KiltCalc
import XCTest

@MainActor
final class KnifePleatDesignerTests: XCTestCase {
  private let designer = PleatDesigner(PleatDesigner.knifePleat)

  func test_countAndWidthSet_WhenFabricThenHipAreSet() {
    designer.pleatFabric = 7
    designer.idealHip = .inches(20)

    XCTAssertEqual(designer.pleatWidth, .number(1))
    XCTAssertEqual(designer.pleatCount, 20)
    XCTAssertEqual(designer.totalFabric, 140)
    XCTAssertEqual(designer.adjustedHip, .number(20))
  }

  func test_countAndWidthSet_WhenHipThenFabricAreSet() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 7

    XCTAssertEqual(designer.pleatWidth, .number(1))
    XCTAssertEqual(designer.pleatCount, 20)
    XCTAssertEqual(designer.totalFabric, 140)
  }

  func test_getPleatCount_WhenPredecessorValuesPresent() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(1)
    XCTAssertEqual(designer.pleatCount, 20)
    XCTAssertEqual(designer.totalFabric, 120)
  }

  func test_getPleatCount_WhenPredecessorValuesChangedToNil() {
    designer.idealHip = nil
    designer.pleatFabric = 6
    designer.pleatWidth = .inches(1)
    XCTAssertEqual(designer.pleatCount, 10)
  }

  func test_getPleatCount_WhenPleatWidthIsNil() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    XCTAssertEqual(designer.pleatCount, 20)

    designer.pleatWidth = nil
    XCTAssertEqual(designer.pleatCount, 20)
  }

  func test_getPleatCount_WhenPleatWidthIs0() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 6
    XCTAssertEqual(designer.pleatCount, 20)

    designer.pleatWidth = .inches(0)
    XCTAssertEqual(designer.pleatCount, 20)
  }

  func test_initialPleatWidthAdjusted_WhenCountIsRounded() {
    designer.idealHip = .inches(1.5)
    designer.pleatFabric = 6
    XCTAssertEqual(designer.pleatCount, 2)
    XCTAssertEqual(designer.pleatWidth, .number(0.75))
  }

  func test_adjustedHip() {
    designer.idealHip = .inches(20)
    designer.pleatFabric = 4
    XCTAssertEqual(designer.pleatCount, 20)
    XCTAssertEqual(designer.pleatWidth, .number(1))

    designer.pleatWidth = .number(1.5)

    XCTAssertEqual(designer.pleatCount, 13)
    XCTAssertEqual(designer.pleatWidth, .number(1.5))
    XCTAssertEqual(designer.adjustedHip, .number(19.5))
    XCTAssertEqual(designer.hipWasAdjusted, true)
  }

  func test_adjustedHipWhenWidthIsNil() {
    designer.idealHip = .inches(20.5)
    designer.pleatFabric = 6
    designer.pleatWidth = nil
    XCTAssertEqual(designer.adjustedHip, nil)
    XCTAssertEqual(designer.hipWasAdjusted, false)
  }

  func test_pleatWidthChangesWhenPleatCountChanges() {
    designer.idealHip = .inches(12)
    designer.pleatFabric = 4
    designer.pleatCount = 8
    XCTAssertEqual(designer.pleatWidth, .number(1.5))
  }

  func test_pleatWidthChangesToNilWhenRequiredFieldGoesToNil() {
    designer.idealHip = .inches(12)
    designer.pleatFabric = 4
    XCTAssertEqual(designer.pleatWidth, .number(1))

    designer.idealHip = nil
    XCTAssertEqual(designer.pleatWidth, nil)
  }

  func test_pleatWidthDoesntChange_WhenRequiredFieldIsNil() {
    designer.idealHip = .inches(12)
    designer.pleatFabric = nil
    XCTAssertEqual(designer.pleatWidth, nil)

    designer.pleatCount = 15
    XCTAssertEqual(designer.pleatWidth, nil)
  }
}
