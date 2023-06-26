import Foundation
import SwiftUI

public struct HistoryItem: Identifiable {
  public var id = UUID()
  let expression: String
  let value: String
}

public class Calculator: ObservableObject {
  @Published private(set) var input = InputBuffer()
  @Published private(set) var history = [HistoryItem]()
  @Published private(set) var result = Value.number(0)
  @Published private(set) var memory = Value.number(0)

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

  func clear() {
    result = .number(0)
    input.clear()
  }

  func memoryClear() {
    memory = .number(0)
  }

  func clearAllHistory() {
    history = []
  }

  func deleteHistory(at indexSet: IndexSet) {
    history.remove(atOffsets: indexSet)
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
    result = Expression(input).evaluate()
    history.append(HistoryItem(
      expression: input.toString(),
      value: valueFormatter.format(imperialFormat.formatter, result)
    ))
    input.clear()
  }

  public func memoryAdd() {
    equals()
    memory = (memory + result)
  }

  public func memoryRecall() {
    input.add(.value(
      memory,
      "\(valueFormatter.format(imperialFormat.formatter, memory)) "
    ))
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

    case .dot:
      operand(entry)

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

    case .value:
      input.add(entry)

    case .slash:
      operand(entry)

    case .leftParend:
      input.add(entry)

    case .rightParend:
      input.add(entry)

    case .memoryClear:
      memoryClear()

    case .memoryAdd:
      memoryAdd()

    case .memoryRecall:
      memoryRecall()

    case .memorySubtract:
      print("\(#file) \(#line) M- not implemented")

    case .pleat:
      print("\(#file) \(#line) pleat not implemented")

    case .ending:
      print("\(#file) \(#line) can't happen")
    }
  }
}
