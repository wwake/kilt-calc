typealias Stack<T> = [T]

//public class Stack<T> {
//
//}

extension Array {
  var top: Element {
    last!
  }

  mutating func push(_ value: Element) {
    append(value)
  }

  mutating func pop() -> Element {
    removeLast()
  }
}
