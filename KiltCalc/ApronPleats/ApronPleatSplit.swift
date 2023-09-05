public struct ApronPleatSplit {
  let equalSplit: Double
  var apronGains: Double = 0.0

  var apron: Double {
    equalSplit + apronGains
  }

  var pleat: Double {
    equalSplit - apronGains
  }

  init(_ total: Double) {
    self.equalSplit = total / 2.0
  }

  mutating func giveApron(_ amount: Double) {
    apronGains = amount
  }
}

extension ApronPleatSplit: Equatable, Hashable {}
