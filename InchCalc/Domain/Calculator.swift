import Foundation

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

  private func isUnit(_ value: String) -> Bool {
    value.hasSuffix(" ")
  }

  private func isOperator(_ string: String) -> Bool {
    ["+", "-", Keypad.multiply, Keypad.divide].contains(string)
  }

  public func clear(_: String) {
    result = .number(0)
    input.clear()
  }

  public func backspace(_: String) {
    input.removeLastIf({ _ in true })
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
