import Foundation

typealias Value = NSNumber

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var value = Value(0)

  public var display: String {
    pending.isEmpty ? "\(value)" : pending
  }

  public func clear(_: String) {
    pending = ""
    alreadyEnteringNewNumber = false
  }

  public func digit(_ digit: String) {
    if !alreadyEnteringNewNumber {
      pending = ""
      alreadyEnteringNewNumber = true
    }
    pending.append(digit)
  }

  public func enter(_: String) {
    let formatter = NumberFormatter()
    value = formatter.number(from: pending)!
    pending = ""
    alreadyEnteringNewNumber = false
  }
}
