import SwiftUI
import ViewInspector
import XCTest

@testable import InchCalc

final class ContentViewTests: XCTestCase {
  fileprivate func display(_ sut: ContentView) throws -> String {
    try sut.inspect().vStack()[0].text().string()
  }

  fileprivate func key(_ sut: ContentView, _ name: String) throws -> InspectableView<ViewType.Text> {
    try sut.inspect().find(text: name)
  }

  func testDigitKeyPress() throws {
    @StateObject var calculator = Calculator()

    let sut = ContentView(calculator: calculator)
    let key = try key(sut, "8")

    try key.callOnTapGesture()

    XCTAssertEqual(try display(sut), "8")
  }
}
