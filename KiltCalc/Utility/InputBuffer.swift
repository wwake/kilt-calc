public struct InputBuffer: Sequence {
  private var elements: [Entry]

  public init(_ elements: [Entry] = []) {
    self.elements = elements
  }

  public var count: Int {
    elements.count
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

  public mutating func removeLastIf(_ condition: (Entry) -> Bool) {
    if !isEmpty && condition(last) {
      elements.removeLast()
    }
  }

  public mutating func removeLastWhile(_ condition: (Entry) -> Bool) {
    while !isEmpty && condition(last) {
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

  public subscript(_ index: Int) -> Entry {
    elements[index]
  }
}
