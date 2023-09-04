import Foundation

public struct ScenarioSplit: Identifiable {
  public var id = UUID()
  let maxApronDifferenceInches = 4.0

  var fieldToSplit: [MeasuringPoint: ApronPleatSplit]

  var warnings: [String] {
    var result: [String] = []
    if self[.waist]!.pleat < self[.waist]!.apron {
      result.append("Pleats should be bigger than apron at waist.")
    }
    if self[.hips]!.pleat < self[.hips]!.apron {
      result.append("Pleats should be bigger than apron at hips.")
    }
    if self[.hips]!.apron < self[.waist]!.apron {
      result.append("Apron at hips should be at least as big as apron at waist.")
    }

    if abs(self[.hips]!.apron - self[.waist]!.apron) > maxApronDifferenceInches {
      result.append("Prefer at most 4” difference between waist and hip in the apron.")
    }
    return result
  }

  var hasWarnings: Bool {
    warnings.count > 0
  }

  init(_ fieldToSize: [MeasuringPoint: Double]) {
    fieldToSplit = fieldToSize.mapValues {
      ApronPleatSplit($0)
    }
  }

  subscript(_ field: MeasuringPoint) -> ApronPleatSplit? {
    get {
      fieldToSplit[field]
    }
    set(newValue) {
      fieldToSplit[field] = newValue
    }
  }

  mutating func givePleat(_ field: MeasuringPoint, _ amount: Double) {
    fieldToSplit[field]?.givePleat(amount)
  }
}

extension ScenarioSplit: Hashable {}
