import EGTest
@testable import KiltCalc
import XCTest

@MainActor
final class PleatValidatorTests: XCTestCase {
  func test_GapMessage() {
    check([
      eg(nil, expect: "Type Can't Be Determined"),
      eg(-0.51, expect: "Military Box Pleat"),
      eg(-0.5, expect: "Box Pleat with Overlap"),
      eg(0, expect: "Box Pleat"),
      eg(0.5, expect: "Box Pleat with Gap"),
      eg(0.51, expect: "Box Pleat with Too-Large Gap"),
    ]) {
      EGAssertEqual(PleatValidator.gapMessage($0.input), $0)
    }
  }
}
