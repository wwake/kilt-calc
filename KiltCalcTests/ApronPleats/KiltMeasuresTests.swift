import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class KiltMeasuresTests: XCTestCase {
  func test_StartingValuesNil() {
    let m = KiltMeasures()
    XCTAssertNil(m.actualWaist)
    XCTAssertNil(m.actualHips)
    XCTAssertNil(m.actualLength)
    XCTAssertNil(m.idealWaist)
    XCTAssertNil(m.idealHips)
    XCTAssertNil(m.idealLength)
  }

  func test_DerivedValuesThatAreAlwaysCopies() throws {
    let m = KiltMeasures()
    m.actualWaist = Value.inches(30)
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
      m.actualWaist = Value.inches($0.input.0)
      m.actualHips = Value.inches($0.input.1)
      EGAssertEqual(m.idealHips!, $0)
    }
  }

  func test_allowsScenarios() {
    let m = KiltMeasures()
    XCTAssertEqual(m.allowsScenarios, false)
    m.actualWaist = Value.inches(22)
    XCTAssertEqual(m.allowsScenarios, false)
    m.actualHips = Value.inches(27)
    XCTAssertEqual(m.allowsScenarios, true)
  }

//  func test_changingActualWaist_MeansIdealValuesChange() {
//    let m = KiltMeasures()
//    XCTAssertEqual(m.idealValues, [nil, nil])
//    m.actualWaist = 20
//    XCTAssertEqual(m.idealValues, [20, nil])
//    m.actualHips = 30
//    XCTAssertEqual(m.idealValues, [20, 30])
//  }
}
