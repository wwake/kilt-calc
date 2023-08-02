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
}
