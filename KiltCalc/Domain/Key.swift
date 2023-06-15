import Foundation

public struct Key: Identifiable {
  public let id = UUID()
  public let name: String
  public let entry: Entry

  init(_ name: String, _ entry: Entry = .tbd("?")) {
    self.name = name
    self.entry = entry
  }
}

extension Key: Equatable {
  public static func == (lhs: Key, rhs: Key) -> Bool {
    lhs.id == rhs.id
  }
}

extension Key: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
