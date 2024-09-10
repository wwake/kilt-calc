import Foundation
import SwiftUI

public struct HistoryItem: Identifiable {
  public var id = UUID()
  let item: String

  init(_ item: String) {
    self.item = item
  }
}

public class Calculator: ObservableObject {
  @Published private(set) var input = InputBuffer()
  @Published private(set) var history = [HistoryItem]()
  @Published private(set) var result = Value.number(0)
  @Published private(set) var memory = Value.number(0)

  @Published private(set) var errorMessage = ""

  @Published private(set) var formattedResult = "0"

  @Published public var imperialFormat = ImperialFormatter.inches
  @Published public var imperialFormatType = Value.ValueFormatStyle.inches

  @Published public var roundingDenominator = 8

  let valueFormatter = ValueFormatter()

  public var display: String {
    let trimmedInput = input.toString().trimmingCharacters(in: .whitespaces)
    if !input.isEmpty {
      return trimmedInput
    }
    return result.formatted(imperialFormatType)
  }

  func clear() {
    result = .number(0)
    input.clear()
  }

  func clearAllHistory() {
    history = []
  }

  func resetError() {
    errorMessage = ""
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
    do {
      result = try Expression(input).evaluate()

      if case let .error(message) = result {
        errorMessage = message
        return
      }
    } catch let error as String {
      errorMessage = error as String
      return
    } catch {
      errorMessage = "Internal error: Calculator.equals()"
      return
    }

    history.append(HistoryItem(
      "\(input.toString()) = \(valueFormatter.format(imperialFormat.formatter, result))"
    ))
    input.clear()
  }

  func memoryClear() {
    memory = .number(0)
  }

  public func memoryAdd() {
    memoryCombine(+, "+")
  }

  public func memorySubtract() {
    memoryCombine(-, "-")
  }

  fileprivate func memoryCombine(_ op: (Value, Value) -> Value, _ opName: String) {
    do {
      result = try Expression(input).evaluate()

      if case let .error(message) = result {
        errorMessage = message
        return
      }
    } catch let error as String {
      errorMessage = error as String
      return
    } catch {
      errorMessage = "Internal error: Calculator.memoryCombine()"
      return
    }

    let temp = op(memory, result)
    if case let .error(message) = temp {
      errorMessage = "\(message); memory left unchanged"
      return
    }

    history.append(HistoryItem(
      "\(input.toString()) = \(valueFormatter.format(imperialFormat.formatter, result)) ⇒M\(opName)"
    ))

    memory = temp
    input.clear()
  }

  public func memoryRecall() {
    input.removeLastWhile { $0.isOperand() }
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

    case .memorySubtract:
      memorySubtract()

    case .memoryRecall:
      memoryRecall()

    case .pleat:
      print("TBD - not sure what to do with this key")

    case .ending:
      print("\(#file) \(#line) can't happen")
    }
  }
}
