import Foundation

public class Calculator: ObservableObject {
  @Published private(set) var alreadyEnteringNewNumber = false
  
  @Published private(set) var pending: String = ""
  
  @Published private(set) var value = Value.number(0)
  
  let formatter = NumberFormatter()
  
  public var display: String {
    if !pending.isEmpty { return pending }
    return value.asString
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
    
    let numbers = pending
      .split(separator: Regex(/[a-z]+/))
      .map { formatter.number(from: String($0)) }
    
    let units = pending.split(separator: Regex(/[0-9]+/))
    
    pending = ""
    
    if numbers.contains(nil) {
      value = .error
      return
    }
    
    if numbers.isEmpty {
      value = Value.error
      return
    }
    
    if numbers.count > 1 && numbers.count != units.count {
      value = Value.error
      return
    }
    
    if numbers.count == 1 && units.count == 0 {
      value = .number(numbers[0]!)
    } else {
      var inches = 0.0
      zip(numbers, units).forEach { number, unit in
        if unit == "in" {
          let possibleNumber = number!
          inches += possibleNumber.doubleValue
        }
      }
      value = Value.unit(NSNumber(0), NSNumber(0), NSNumber(value: inches))
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
