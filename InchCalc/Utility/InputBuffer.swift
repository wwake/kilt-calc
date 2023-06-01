public struct InputBuffer: Sequence {
  private var elements: [String]

  public init(_ elements: [String] = []) {
    self.elements = elements
  }

  public func makeIterator() -> IndexingIterator<[String]> {
    elements.makeIterator()
  }

  public var isEmpty: Bool {
    elements.count == 0
  }

  public var last: String {
    elements.last!
  }

  public mutating func add(_ value: String) {
    elements.append(value)
  }

  public mutating func removeLastIf(_ condition: (String) -> Bool) {
    if !isEmpty && condition(last) {
      elements.removeLast()
    }
  }

  public mutating func clear() {
    elements.removeAll()
  }

  public func toString() -> String {
    elements.joined()
  }
}
