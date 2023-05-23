import Foundation

public class Calculator: ObservableObject {
  @Published public var display: String = "0"
  @Published private(set) var alreadyEnteringNewNumber = false

  public func clear(_: String) {
    display = "0"
    alreadyEnteringNewNumber = false
  }

  public func digit(_ digit: String) {
    if !alreadyEnteringNewNumber {
      display = ""
      alreadyEnteringNewNumber = true
    }
    display.append(digit)
  }

  public func enter(_: String) {
    alreadyEnteringNewNumber = false
  }
}
