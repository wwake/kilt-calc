import Foundation

public struct InputBuffer {
  var elements: [String]

  public init(_ elements: [String] = []) {
    self.elements = elements
  }

  public var isEmpty: Bool {
    elements.count == 0
  }

  public var top: String {
    elements.last!
  }

  public mutating func push(_ value: String) {
    elements.append(value)
  }

  public mutating func pop() -> String {
    elements.removeLast()
  }

  public mutating func clear() {
    elements.removeAll()
  }

  public func joined() -> String {
    elements.joined()
  }
}

public class Calculator: ObservableObject {
  @Published private(set) var result = Value.number(0)
  @Published private(set) var input = InputBuffer()

  let formatter = NumberFormatter()

  public var display: String {
    if !input.isEmpty {
      return input.joined().trimmingCharacters(in: .whitespaces)
    }
    return result.format(ImperialFormatter.asYardFeetInches)
  }

  public func clear(_: String) {
    result = .number(0)
    input.clear()
  }

  public func digit(_ digit: String) {
    input.push(digit)
  }

  public func unit(_ value: String) {
    if !input.isEmpty && input.top.hasSuffix(" ") {
      _ = input.pop()
    }

    input.push(" \(value) ")
  }

  private func isOperator(_ string: String) -> Bool {
    ["+", "-", Keypad.multiply, Keypad.divide].contains(string)
  }

  public func op(_ op: String) {
    if !input.isEmpty {
      let lastChar = input.top
      if ["+", "-", Keypad.multiply, Keypad.divide].contains(lastChar) {
        _ = input.pop()
      }
    }

    input.push(op)
  }

  public func enter(_: String) {
    if !input.isEmpty && isOperator(input.top) {
      result = .error("expression can't end with an operator")
    } else {
      result = Expression(input).evaluate()
    }
    input.clear()
  }
}
