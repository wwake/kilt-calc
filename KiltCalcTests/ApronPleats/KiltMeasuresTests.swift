import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class KiltMeasuresTests: XCTestCase {
  func test_DerivedValuesThatAreAlwaysCopies() throws {
    let m = KiltMeasures()
    m.actualWaist = 30
    m.actualLength = 25

    XCTAssertEqual(m.idealWaist, 30)
    XCTAssertEqual(m.idealLength, 25)
  }

  func test_IdealHips() {
    check(
      eg((30.0, 31.0), expect: 31.0, "hip > waist"),
      eg((30.0, 30.0), expect: 30.0, "hip = waist"),
      eg((30.0, 29.0), expect: 30.0, "hip < waist")
    ) {
      let m = KiltMeasures()
      m.actualWaist = $0.input.0
      m.actualHips = $0.input.1
      EGAssertEqual(m.idealHips, $0)
    }
  }
}
