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

  private func clear() {
    result = .number(0)
    input.clear()
  }

  private func backspace() {
    input.removeLastIf({ _ in true })
  }

  private func digit(_ digit: String) {
    input.add(digit)
  }

  private func enterUnit(_ entry: Entry) {
    let unit = entry.asUnit()
    input.removeLastIf(isUnit)
    input.add(" \(unit.description) ")
  }

  private func op(_ op: String) {
    input.removeLastIf(isOperator)
    input.add(op)
  }

   private func equals() {
    if !input.isEmpty && isOperator(input.last) {
      result = .error("expression can't end with an operator")
    } else {
      result = Expression(input).evaluate()
    }
    input.clear()
  }

  public func enter(_ entry: Entry) {
    switch entry {
    case .clear:
      clear()

    case .backspace:
      backspace()

    case .equals:
      equals()

    case .unit:
      enterUnit(entry)

    case .add:
      op("+")

    case .subtract:
      op("-")

    case .multiply:
      op(Keypad.multiply)

    case .divide:
      op(Keypad.divide)

    case .digit(let value):
      digit("\(value)")
    }
  }
}
