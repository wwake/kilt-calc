public struct InputBuffer: Sequence {
  private var elements: [Entry]

  public init(_ elements: [Entry] = []) {
    self.elements = elements
  }

  public func makeIterator() -> IndexingIterator<[Entry]> {
    elements.makeIterator()
  }

  public var isEmpty: Bool {
    elements.count == 0
  }

  public var last: Entry {
    elements.last!
  }

  public mutating func add(_ value: Entry) {
    elements.append(value)
  }

  public mutating func removeLastIf(_ condition: (String) -> Bool) {
    if !isEmpty && condition(last.description) {
      elements.removeLast()
    }
  }

  public mutating func clear() {
    elements.removeAll()
  }

  public func toString() -> String {
    elements
      .map { $0.description }
      .joined()
  }
}
