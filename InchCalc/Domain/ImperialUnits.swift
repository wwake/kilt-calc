public enum ImperialUnits {
  static let inchesPerInch = 1.0
  static let inchesPerFoot = 12.0
  static let inchesPerYard = 36.0
  static let feetPerYard = 3.0

  static var ratios = [
    "yd": inchesPerYard,
    "ft": inchesPerFoot,
    "in": inchesPerInch,
  ]

  static func ratioFor(_ unit: String) -> Double {
    ratios[unit] ?? 1.0
  }
}
