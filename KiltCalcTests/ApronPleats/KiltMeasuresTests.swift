@testable import KiltCalc
import XCTest

public class KiltMeasures {
  public var actualWaist = 0.0
  public var actualHips = 0.0
  public var actualLength = 0.0

  public var idealWaist: Double {
    actualWaist
  }

  public var idealHips: Double {
    actualWaist > actualHips
      ? actualWaist
      : actualHips
  }

  public var idealLength: Double {
    actualLength
  }
}

@MainActor
final class KiltMeasuresTests: XCTestCase {
  func test_DerivedValuesThatAreAlwaysCopies() throws {
    let m = KiltMeasures()
    m.actualWaist = 30
    m.actualLength = 25

    XCTAssertEqual(m.idealWaist, 30)
    XCTAssertEqual(m.idealLength, 25)
  }

  func test_HipValueCopiedWhenHipBiggerThanWaist() throws {
    let m = KiltMeasures()
    m.actualWaist = 30
    m.actualHips = 31

    XCTAssertEqual(m.idealHips, 31)
  }

  func test_HipValueCopiedWhenHipEqualWaist() throws {
    let m = KiltMeasures()
    m.actualWaist = 30
    m.actualHips = 30

    XCTAssertEqual(m.idealHips, 30)
  }

  func test_UseWaistForHipsWhenHipsSmallerThanWaist() throws {
    let m = KiltMeasures()
    m.actualWaist = 30
    m.actualHips = 29

    XCTAssertEqual(m.idealHips, 30)
  }
}
