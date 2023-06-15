import EGTest
import XCTest

@testable import KiltCalc

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

public func EGAssertEqual<T: Equatable, Input>(_ actual: T, _ expected: EG<Input, T>) {
  XCTAssertEqual(
    actual, expected.expect, expected.message, file: expected.file, line: expected.line
  )
}
