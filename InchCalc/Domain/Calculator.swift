import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var result = Value.number(0)
  @Published private(set) var input = InputBuffer()
  let valueFormatter = ValueFormatter()

  public var display: String {
    if !input.isEmpty {
      return input.toString().trimmingCharacters(in: .whitespaces)
    }
    return valueFormatter.format(ImperialFormatter.asYardFeetInches, result)
  }

  private func clear() {
    result = .number(0)
    input.clear()
  }

  private func backspace() {
    input.removeLastIf({ _ in true })
  }

  private func digit(_ entry: Entry) {
    input.add(entry)
  }

  private func enterUnit(_ entry: Entry) {
    input.removeLastIf { $0.isUnit() }
    input.add(entry)
  }

  private func op(_ entry: Entry) {
    input.removeLastIf { $0.isBinaryOperator() }
    input.add(entry)
  }

   private func equals() {
     if !input.isEmpty && input.last.isBinaryOperator() {
      result = .error("expression can't end with an operator")
    } else {
      result = Expression(input).evaluate()
    }
    input.clear()
  }

  public func enter(_ entry: Entry) {
    switch entry {
    case .tbd:
      print("TBD")

    case .clear:
      clear()

    case .backspace:
      backspace()

    case .equals:
      equals()

    case .unit:
      enterUnit(entry)

    case .binary, .unary:
      op(entry)

    case .digit:
      let previousEntry = input.isEmpty ? nil : input.last
      if previousEntry != nil, previousEntry!.isUnaryOperator {
        input.removeLastIf { _ in true }
        digit(entry)
        input.add(previousEntry!)
      } else {
        digit(entry)
      }
    }
  }
}
