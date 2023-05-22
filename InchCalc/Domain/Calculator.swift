import Foundation

public class Calculator: ObservableObject {
  @Published public var display: String = "0"
  private var startingNewNumber = true

  public func digit(_ digit: String) {
    if startingNewNumber {
      display = ""
      startingNewNumber = false
    }
    display.append(digit)
  }

  public func enter(_ : String) {
    startingNewNumber = true
  }
}
