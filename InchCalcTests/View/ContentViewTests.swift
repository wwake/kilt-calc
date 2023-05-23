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
  fileprivate func display(_ sut: ContentView) throws -> InspectableView<ViewType.Text> {
    try sut.inspect().vStack()[0].text()
  }

  fileprivate func key(_ sut: ContentView, _ name: String) throws -> InspectableView<ViewType.Text> {
    try sut.inspect().vStack()[1].find(text: name)
  }

  func testAllDigitKeyPresses() throws {
    try check([
      EG("0", expect: "0"),
      EG("1", expect: "1"),
      EG("2", expect: "2"),
      EG("3", expect: "3"),
      EG("4", expect: "4"),
      EG("5", expect: "5"),
      EG("6", expect: "6"),
      EG("7", expect: "7"),
      EG("8", expect: "8"),
      EG("9", expect: "9"),
    ]) {
      try checkDigitKeyPress($0.input, $0.expect)
    }
  }

  private func checkDigitKeyPress(_ keyName: String, _ expectedDisplayText: String) throws {
    @StateObject var calculator = Calculator()

    let sut = ContentView(calculator: calculator)
    let key = try key(sut, keyName)

    try key.callOnTapGesture()

    XCTAssertEqual(try display(sut).string(), expectedDisplayText)
  }
}
