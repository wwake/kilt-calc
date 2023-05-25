import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var value = Value.number(0)

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }
    return value.description
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

  fileprivate func parse(_ input: String) -> Value {
    let numbers = input
      .split(separator: Regex(/[a-z]+/))
      .map { formatter.number(from: String($0)) }

    let units = input.split(separator: Regex(/[0-9]+/))

    if numbers.contains(nil) {
      return .error
    }

    if numbers.isEmpty {
      return .error
    }

    if numbers.count > 1 && numbers.count != units.count {
      return .error
    }

    if numbers.count == 1 && units.count == 0 {
      return .number(numbers[0]!)
    } else {
      var inches = 0.0
      zip(numbers, units).forEach { number, unit in
        if unit == "in" {
          let possibleNumber = number!
          inches += possibleNumber.doubleValue
        }
      }
      return Value.unit(NSNumber(value: inches))
    }
  }

  fileprivate func encodePendingValue() {
    guard !pending.isEmpty else { return }
    value = parse(pending)
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
