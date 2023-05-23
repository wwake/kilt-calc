import EGTest
import SwiftUI
import ViewInspector
import XCTest

@testable import InchCalc

extension XCTestCase {
  func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ assertFunction: (EG<Input, Output>) throws -> Void
  ) throws {
    try tests.forEach {
      try assertFunction($0)
    }
  }
}

final class ContentViewTests: XCTestCase {
  fileprivate func display(_ sut: ContentView) throws -> String {
    try sut.inspect().vStack()[0].text().string()
  }

  fileprivate func key(_ sut: ContentView, _ name: String) throws -> InspectableView<ViewType.Text> {
    try sut.inspect().vStack()[1].find(text: name)
  }

  func testAllDigitKeyPresses() throws {
    try check([
      EG("0", expect: "0")
    ]) {
      try checkDigitKeyPress($0.input, $0.expect)
    }
  }

  private func checkDigitKeyPress(_ keyName: String, _ expectedDisplayText: String) throws {
    @StateObject var calculator = Calculator()

    let sut = ContentView(calculator: calculator)
    let key = try key(sut, keyName)

    try key.callOnTapGesture()

    XCTAssertEqual(try display(sut), expectedDisplayText)
  }
}
