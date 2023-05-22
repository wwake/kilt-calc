import Foundation

struct Key: Identifiable, Hashable {
  let id = UUID()
  let name: String

  init(_ name: String) {
    self.name = name
  }
}
