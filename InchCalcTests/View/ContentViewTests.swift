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
    try sut.inspect().find(ViewType.Text.self)
  }

  fileprivate func key(_ sut: ContentView, _ name: String) -> InspectableView<ViewType.Button> {
    do {
      return try sut.inspect().find(button: name)
    } catch {
      fatalError("ContentViewTests - referenced unknown key \(name)")
    }
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
    let key = key(sut, keyName)

    try key.tap()

    XCTAssertEqual(try display(sut).string(), expectedDisplayText)
  }

  func testClearResetsDisplay() throws {
    @StateObject var calculator = Calculator()

    let sut = ContentView(calculator: calculator)
    let key4 = key(sut, "4")
    try key4.tap()
    XCTAssertEqual(try display(sut).string(), "4")

    let keyClear = key(sut, "C")
    try keyClear.tap()

    XCTAssertEqual(try display(sut).string(), "0")
  }

  private func tap(_ sut: ContentView, _ input: String) throws {
    try input.forEach { keyName in
      switch keyName {
      case " ":
        break

      case "y":
        try key(sut, "yd").tap()

      case "f":
        try key(sut, "ft").tap()

      case "i":
        try key(sut, "in").tap()

      case "d", "t", "n":  // ignore second letter of unit
        break

      default:
        try key(sut, String(keyName)).tap()
      }
    }
  }

  func testCalculations() throws {
    try check([
      EG("1yd 5ft 11in =", expect: "2 yd 2 ft 11 in", "all units"),
      EG("1+5=", expect: "6", "Number addition"),
    ]) {
      @StateObject var calculator = Calculator()

      let sut = ContentView(calculator: calculator)
      try tap(sut, $0.input)

      XCTAssertEqual(try display(sut).string(), $0.expect, $0.message)
    }
  }
}
