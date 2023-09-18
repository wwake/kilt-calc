import Foundation

public struct KiltMeasures {
  public var actualWaist: Value?
  public var actualHips: Value?
  public var actualLength: Value?

  init(actualWaist: Double? = nil, actualHips: Double? = nil, actualLength: Double? = nil) {
    self.actualWaist = actualWaist == nil ? nil : Value.inches(actualWaist!)
    self.actualHips = actualHips == nil ? nil : Value.inches(actualHips!)
    self.actualLength = actualLength == nil ? nil : Value.inches(actualLength!)
  }

  public var idealWaist: Double? {
    actualWaist?.asDouble
  }

  public var idealHips: Double? {
    if !allowsScenarios {
      return nil
    }

    return max(actualWaist!, actualHips!).asDouble
  }

  public var idealLength: Double? {
    actualLength?.asDouble
  }

  public var allowsScenarios: Bool {
    actualWaist != nil && actualHips != nil
  }
}
