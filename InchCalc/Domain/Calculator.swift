import Foundation

public enum Value {
  case error
  case number(NSNumber)
  case unit(NSNumber)
}

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false

  @Published private(set) var pending: String = ""

  @Published private(set) var value = Value.number(0)

  let formatter = NumberFormatter()

  public var display: String {
    if !pending.isEmpty { return pending }

    switch value {
    case .error:
      return "error"

    case .number(let aNumber):
      return formatter.string(from: aNumber) ?? ""

    case .unit(let theInches):
      let inches = formatter.string(from: theInches) ?? ""
      return "\(inches) in"
    }
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

    do {
      let numbers = try pending.split(separator: Regex("[a-z]+"))
      let units = try pending.split(separator: Regex("[0-9]+"))

      pending = ""
      if numbers.isEmpty {
        value = Value.error
      } else if numbers.count == 1 && units.count == 0 {
        let possibleNumber = formatter.number(from: String(numbers[0]))
        value = possibleNumber == nil ? .error : .number(possibleNumber!)
      } else if numbers.count != units.count {
        value = .error
      } else {
        var inches = 0.0
        zip(numbers, units).forEach { number, unit in
          if unit == "in" {
            let possibleNumber = formatter.number(from: String(number))!
            inches += possibleNumber.doubleValue
          }
        }
        value = Value.unit(NSNumber(value: inches))
      }
    } catch {
      // can't happen
    }
  }

  public func enter(_: String) {
    encodePendingValue()
    alreadyEnteringNewNumber = false
  }

  public func unit(_ value: String) {
    pending.append(value)
  }
}
