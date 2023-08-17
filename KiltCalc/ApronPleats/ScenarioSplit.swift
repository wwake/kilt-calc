import Foundation

public struct ScenarioSplit: Identifiable {
  public var id = UUID()
  var fieldToSplit: [MeasuringPoint: ApronPleatSplit]

  init(_ fieldToSize: [MeasuringPoint: Double]) {
    fieldToSplit = fieldToSize.mapValues {
      ApronPleatSplit($0)
    }
  }

  subscript(_ field: MeasuringPoint) -> ApronPleatSplit? {
    fieldToSplit[field]
  }

  mutating func givePleat(_ field: MeasuringPoint, _ amount: Double) {
    fieldToSplit[field]?.givePleat(amount)
  }
}

extension ScenarioSplit: Hashable {}
