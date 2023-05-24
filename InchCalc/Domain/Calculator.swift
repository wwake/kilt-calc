import Foundation

public class Calculator: ObservableObject {
  public var display: String {
    pending
  }

  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = "0"

  public func clear(_: String) {
    pending = "0"
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
