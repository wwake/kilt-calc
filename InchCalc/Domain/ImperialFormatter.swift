import Foundation

public typealias ImperialFormatterFunction = (NumberFormatter, Double) -> String

public enum ImperialFormatter {
  static func formatNumber(_ formatter: NumberFormatter, _ value: Double) -> String {
    if value.isInfinite {
      return "result too large"
    }
    let result = formatter.string(from: NSNumber(value: value)) ?? ""
    return "\(result)"
  }

  static func asInches(_ formatter: NumberFormatter, _ inches: Double) -> String {
    "\(formatNumber(formatter, inches)) in"
  }

  static func asYardFeetInches(_ formatter: NumberFormatter, _ inches: Double) -> String {
    let yfi = [(ImperialUnit.inchesPerYard, "yd"), (ImperialUnit.inchesPerFoot, "ft"), (1, "in")]

    let sign = inches < 0 ? "-" : ""
    var remaining = abs(inches)

    var partials: [(Double, String)] = []

    yfi.forEach { minorUnitsPerMajor, label in
      let major = floor(remaining / minorUnitsPerMajor)
      remaining -= major * minorUnitsPerMajor

      if major != 0.0 { partials.append((major, label)) }
    }

    if partials.isEmpty { return "0 in" }

    return partials.map { number, label in
      let numericPart = formatNumber(formatter, number)
      return "\(sign)\(numericPart) \(label)"
    }
    .joined(separator: " ")
  }
}
