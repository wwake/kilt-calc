import Foundation

public class KiltMeasures: ObservableObject {
  @Published public var actualWaist: Value?
  @Published public var actualHips: Double?
  @Published public var actualLength: Double?

  init(actualWaist: Double? = nil, actualHips: Double? = nil, actualLength: Double? = nil) {
    self.actualWaist = actualWaist == nil ? nil : Value.inches(actualWaist!)
    self.actualHips = actualHips
    self.actualLength = actualLength
  }

  public var actualWaistDouble: Double? {
      actualWaist?.asDouble ?? nil
  }

  public var idealWaist: Double? {
    actualWaistDouble
  }

  public var idealHips: Double? {
    if !allowsScenarios {
      return nil
    }

    return actualWaistDouble! > actualHips!
    ? actualWaistDouble
    : actualHips
  }

  public var idealLength: Double? {
    actualLength
  }

  public var allowsScenarios: Bool {
    actualWaistDouble != nil && actualHips != nil
  }
}
