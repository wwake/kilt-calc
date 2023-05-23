import SwiftUI
import XCTest
import ViewInspector

@testable import InchCalc

final class ContentViewTests: XCTestCase {
  @StateObject private var calculator = Calculator()

  func testStringValue() throws {
    let sut = ContentView(calculator: calculator)
    let key8 = try sut.inspect().find(text: "8")

    try key8.callOnTapGesture()

    let display = try sut.inspect().vStack()[0].text().string()

    XCTAssertEqual(display, "8")
  }
}
