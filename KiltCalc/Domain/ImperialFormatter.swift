import Foundation

public typealias ImperialFormatterFunction = (NumberFormatter, Double) -> String

public enum ImperialFormatter: String, CaseIterable, Equatable, Identifiable {
  public var id: Self { self }

  case inches = "Display: in"
  case yardFeetInches = "Display: yd·ft·in"

  public var formatter: ImperialFormatterFunction {
    switch self {
    case .inches:
      return Self.asInches

    case .yardFeetInches:
      return Self.asYardFeetInches
    }
  }

  static func formatNumber(_ formatter: NumberFormatter, _ value: Double, _ label: String) -> String {
    let result = formatter.string(from: NSNumber(value: value)) ?? "internal error"

    if value.isInfinite || value.isNaN {
      return result
    }

    return "\(result) \(label)"
  }

  static func asInches(_ formatter: NumberFormatter, _ inches: Double) -> String {
    formatNumber(formatter, inches, "in")
  }

  static func asYardFeetInches(_ formatter: NumberFormatter, _ inches: Double) -> String {
    let yfi = [(ImperialUnit.inchesPerYard, "yd"), (ImperialUnit.inchesPerFoot, "ft"), (1, "in")]

    let sign = inches < 0 ? -1.0 : 1.0
    var remaining = abs(inches)

    var partials: [(Double, String)] = []

    yfi.forEach { minorUnitsPerMajor, label in
      let major = floor(remaining / minorUnitsPerMajor)
      remaining -= major * minorUnitsPerMajor

      if major != 0.0 { partials.append((major, label)) }
    }

    if partials.isEmpty { return "0 in" }

    return partials.map { number, label in
      formatNumber(formatter, sign * number, label)
    }
    .joined(separator: " ")
  }
}
