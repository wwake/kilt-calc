public struct Stack<Element> {
  var elements: [Element]

  init(_ elements: [Element] = []) {
    self.elements = elements
  }

  var isEmpty: Bool {
    elements.count == 0
  }

  var top: Element {
    elements.last!
  }

  mutating func push(_ value: Element) {
    elements.append(value)
  }

  mutating func pop() -> Element {
    elements.removeLast()
  }
}
