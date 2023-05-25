import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var value = Value.number(0)

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }
    return value.description(ImperialFormatter.asInches)
  }

  public func clear(_: String) {
    pending = ""
    alreadyEnteringNewNumber = false
    value = .number(0)
  }

  public func digit(_ digit: String) {
    if !alreadyEnteringNewNumber {
      pending = ""
      alreadyEnteringNewNumber = true
    }
    pending.append(digit)
  }

  fileprivate func encodePendingValue() {
    guard !pending.isEmpty else { return }
    value = Value.parse(pending)
    pending = ""
  }

  public func enter(_: String) {
    encodePendingValue()
    alreadyEnteringNewNumber = false
  }

  public func unit(_ value: String) {
    pending.append(value)
  }
}
