public struct ApronPleatSplit {
  let equalSplit: Double
  var pleatSteals: Double = 0.0

  var apron: Double {
    equalSplit - pleatSteals
  }

  var pleat: Double {
    equalSplit + pleatSteals
  }

  init(_ total: Double) {
    self.equalSplit = total / 2.0
  }

  mutating func giveApron(_ amount: Double) {
    pleatSteals = -amount
  }
}

extension ApronPleatSplit: Equatable, Hashable {}
