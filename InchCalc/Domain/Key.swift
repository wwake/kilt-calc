import Foundation

struct Key: Identifiable {
  let id = UUID()
  let name: String
  let action: (String) -> Void

  init(_ name: String, _ action: @escaping (String) -> Void = {_ in }) {
    self.name = name
    self.action = action
  }
}

extension Key: Equatable {
  static func == (lhs: Key, rhs: Key) -> Bool {
    lhs.id == rhs.id
  }
}

extension Key: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
