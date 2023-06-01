import Foundation

public struct InputBuffer {
  var elements: [String]

  public init(_ elements: [String] = []) {
    self.elements = elements
  }

  public var isEmpty: Bool {
    elements.count == 0
  }

  public var last: String {
    elements.last!
  }

  public mutating func add(_ value: String) {
    elements.append(value)
  }

  public mutating func removeLastIf(_ condition: (String) -> Bool) {
    if !isEmpty && condition(last) {
      elements.removeLast()
    }
  }

  public mutating func clear() {
    elements.removeAll()
  }

  public func toString() -> String {
    elements.joined()
  }
}

public class Calculator: ObservableObject {
  @Published private(set) var result = Value.number(0)
  @Published private(set) var input = InputBuffer()

  let formatter = NumberFormatter()

  public var display: String {
    if !input.isEmpty {
      return input.toString().trimmingCharacters(in: .whitespaces)
    }
    return result.format(ImperialFormatter.asYardFeetInches)
  }

  public func isUnit(_ value: String) -> Bool {
    value.hasSuffix(" ")
  }

  private func isOperator(_ string: String) -> Bool {
    ["+", "-", Keypad.multiply, Keypad.divide].contains(string)
  }

  public func clear(_: String) {
    result = .number(0)
    input.clear()
  }

  public func digit(_ digit: String) {
    input.add(digit)
  }

  public func unit(_ value: String) {
    input.removeLastIf(isUnit)
    input.add(" \(value) ")
  }

  public func op(_ op: String) {
    input.removeLastIf(isOperator)
    input.add(op)
  }

  public func enter(_: String) {
    if !input.isEmpty && isOperator(input.last) {
      result = .error("expression can't end with an operator")
    } else {
      result = Expression(input).evaluate()
    }
    input.clear()
  }
}
