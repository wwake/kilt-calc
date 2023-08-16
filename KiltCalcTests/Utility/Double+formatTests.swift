import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class Double_formatTests: XCTestCase {
  func test_fractionsDownTo1_4() throws {
    check(
      eg(0.0, expect: "0"),
      eg(0.25, expect: "¼"),
      eg(0.5, expect: "½"),
      eg(0.75, expect: "¾"),
      eg(1, expect: "1"),
      eg(1.25, expect: "1\u{2022}¼"),
      eg(1.5, expect: "1\u{2022}½"),
      eg(1.75, expect: "1\u{2022}¾"),
      eg(2.25, expect: "2\u{2022}¼")
    ) {
      EGAssertEqual($0.input.formatQuarter(), $0)
    }
  }

  func test_fractionsThatArentQuarters() {
    check(
      eg(0.001, expect: "0"),
      eg(0.999, expect: "1"),
      eg(0.74, expect: "¾"),
      eg(0.76, expect: "¾")
    ) {
      EGAssertEqual($0.input.formatQuarter(), $0)
    }
  }
}
