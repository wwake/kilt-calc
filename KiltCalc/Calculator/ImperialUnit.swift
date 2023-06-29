public enum ImperialUnit {
  case unspecified
  case inch
  case foot
  case yard

  static let inchesPerInch = 1.0
  static let inchesPerFoot = 12.0
  static let inchesPerYard = 36.0
  static let feetPerYard = 3.0

  static var ratios = [
    "": 1.0,
    "yd": inchesPerYard,
    "ft": inchesPerFoot,
    "in": inchesPerInch,
  ]

  static func asInches(_ number: Double, _ unit: String) -> Double {
    number * (ratios[unit] ?? 1.0)
  }
}

extension ImperialUnit: CustomStringConvertible {
  public var description: String {
    switch self {
    case .unspecified:
      return ""
    case .inch:
      return "in"
    case .foot:
      return "ft"
    case .yard:
      return "yd"
    }
  }
}
