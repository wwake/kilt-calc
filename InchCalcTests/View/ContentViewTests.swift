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
      try checkDigitKeyPress($0)
    }
  }

  private func checkDigitKeyPress(_ eg: EG<String, String>) throws {
    let sut = ContentView(calculator: Calculator())

    try key(sut, eg.input).tap()

    XCTAssertEqual(try display(sut).string(), eg.expect, file: eg.file, line: eg.line)
  }

  func testClearResetsDisplay() throws {
    let sut = ContentView(calculator: Calculator())
    let key4 = key(sut, "4")
    try key4.tap()
    XCTAssertEqual(try display(sut).string(), "4")

    let keyClear = key(sut, "C")
    try keyClear.tap()

    XCTAssertEqual(try display(sut).string(), "0")
  }

  private func tap(_ sut: ContentView, _ input: String) throws {
    var firstLetter: Character = " "

    try input.forEach { keyName in
      switch keyName {
      case " ":
        break

      case "<":
        try key(sut, "\(Keypad.backspace)").tap()

      case "*":
        try key(sut, "\(Keypad.multiply)").tap()

      case ":":
        try key(sut, "\(Keypad.divide)").tap()

      case ".":
        try key(sut, "\(Keypad.dot)").tap()

      case "~":
        try key(sut, "\(Keypad.plusOrMinus)").tap()

      case "y", "f", "i", "M":
        firstLetter = keyName

      case "d":
        if firstLetter == "y" {
          try key(sut, "yd").tap()
          firstLetter = " "
        }

      case "t":
        if firstLetter == "f" {
          try key(sut, "ft").tap()
          firstLetter = " "
        }

      case "n":
        if firstLetter == "i" {
          try key(sut, "in").tap()
          firstLetter = " "
        }

      case "C", "R", "+", "-":
        if firstLetter == "M" {
          try key(sut, "M\(keyName)").tap()
          firstLetter = " "
        } else {
          try key(sut, String(keyName)).tap()
        }

      default:
        try key(sut, String(keyName)).tap()
      }
    }
  }

  func testCalculations() throws {
    try check([
      EG("1yd 5ft 11in =", expect: "2 yd 2 ft 11 in", "all units"),
      EG("1+5=", expect: "6", "Number addition"),
      EG("5-1=", expect: "4", "Number subtraction"),
      EG("5-3-2=", expect: "0", "Associativity of -"),
      EG("5*3*2=", expect: "30", "Associativity of *"),
      EG("5+3*2=", expect: "11", "Precedence of * over +"),
      EG("6:3=", expect: "2", "Number division"),
      EG("5ft", expect: "5 ft", "Typing unit inserts spaces"),
      EG("2yd5ft", expect: "2 yd 5 ft", "Typing unit inserts spaces"),
      EG("ft 3 in 2=", expect: "1 yd 2 in", "Units may precede numbers"),
      EG("2 yd ft", expect: "2 ft", "Last unit takes precedence"),
      EG("2 yd ft =", expect: "2 ft", "Last unit takes precedence"),
      EG("5 ft 2 =", expect: "numbers and units don't match", "more numbers than units"),
    ]) {
      let sut = ContentView(calculator: Calculator())
      try tap(sut, $0.input)

      XCTAssertEqual(try display(sut).string(), $0.expect, $0.message, file: $0.file, line: $0.line)
    }
  }
}
