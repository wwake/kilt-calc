import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var input = InputBuffer()
  @Published private(set) var previous = ("0", "0")
  @Published private(set) var result = Value.number(0)

  @Published private(set) var formattedResult = "0"

  @Published public var imperialFormat = ImperialFormatter.inches
  @Published public var roundingDenominator = 8

  let valueFormatter = ValueFormatter()

  public var display: String {
    let trimmedInput = input.toString().trimmingCharacters(in: .whitespaces)
    if !input.isEmpty {
      return trimmedInput
    }
    return valueFormatter.format(imperialFormat.formatter, result)
  }

  private func clear() {
    result = .number(0)
    input.clear()
  }

  private func backspace() {
    input.removeLastIf({ _ in true })
  }

  private func operand(_ entry: Entry) {
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
     previous = (input.toString(), valueFormatter.format(imperialFormat.formatter, result))
    input.clear()
  }

  public func enter(_ entry: Entry) {
    switch entry {
    case .tbd(let ch):
      print("\(#file) \(#line) TBD(\(ch)")

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
        operand(entry)
        input.add(previousEntry!)
      } else {
        operand(entry)
      }

    case .slash:
      operand(entry)

    case .leftParend:
      input.add(entry)

    case .rightParend:
      input.add(entry)

    case .ending:
      print("\(#file) \(#line) can't happen")
    }
  }
}
