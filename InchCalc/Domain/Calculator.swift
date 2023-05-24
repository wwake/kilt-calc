import Foundation

public class Calculator: ObservableObject {
  public var display: String {
    pending.isEmpty ? "0" : pending
  }

  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

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
    alreadyEnteringNewNumber = false
  }
}
