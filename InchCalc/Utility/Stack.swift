public struct Stack<Element> {
  var elements: [Element]

  public init(_ elements: [Element] = []) {
    self.elements = elements
  }

  public var isEmpty: Bool {
    elements.count == 0
  }

  public var top: Element {
    elements.last!
  }

  public mutating func push(_ value: Element) {
    elements.append(value)
  }

  public mutating func pop() -> Element {
    elements.removeLast()
  }

  public mutating func clear() {
    elements.removeAll()
  }
}
