import Foundation

public struct Key: Identifiable {
  public let id = UUID()
  let name: String
  let action: (String) -> Void

  init(_ name: String, _ action: @escaping (String) -> Void = { _ in }) {
    self.name = name
    self.action = action
  }

  public func press() {
    action(name)
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
