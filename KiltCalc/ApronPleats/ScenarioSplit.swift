import Foundation

public struct ScenarioSplit: Identifiable {
  public var id = UUID()
  var fieldToSplit: [MeasuringPoint: ApronPleatSplit]

  var warnings: [String] {
    var result: [String] = []
    if self[.waist]!.pleat < self[.waist]!.apron {
      result.append("Pleats should be bigger than apron at waist")
    }
    if self[.hips]!.pleat < self[.hips]!.apron {
      result.append("Pleats should be bigger than apron at hips")
    }
    return result
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
