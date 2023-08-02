@testable import KiltCalc
import XCTest

@MainActor
final class KnifePleatDesignerTests: XCTestCase {
  func test_initializesCorrectly() throws {
    let designer = KnifePleatDesigner()
    XCTAssertEqual(designer.idealHip, nil)
    XCTAssertEqual(designer.pleatFabric, nil)
    XCTAssertEqual(designer.pleatWidth, nil)
    XCTAssertEqual(designer.pleatCount, 10)
    XCTAssertEqual(designer.gap, nil)
  }
}
