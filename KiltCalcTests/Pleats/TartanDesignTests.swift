@testable import KiltCalc
import XCTest

@MainActor
final class TartanDesignTests: XCTestCase {
  func test_initialization() throws {
    let tartan = TartanDesign()

    XCTAssertEqual(tartan.sett, nil)
    XCTAssertEqual(tartan.settsPerPleat, 1.0)
    XCTAssertEqual(tartan.pleatFabric, nil)
  }

  func test_SettsPerPleat_MustStayAtLeastOneHalf() {
    let tartan = TartanDesign()

    tartan.settsPerPleat = 0.49
    XCTAssertEqual(tartan.settsPerPleat, 0.5)

    tartan.settsPerPleat = 0.5
    XCTAssertEqual(tartan.settsPerPleat, 0.5)
  }

  func test_PleatFabricIsProductOfSettAndSettsPerPleat() {
    let tartan = TartanDesign()
    tartan.sett = .inches(10)
    tartan.settsPerPleat = 0.75

    XCTAssertEqual(tartan.pleatFabric, 7.5)
  }
}
