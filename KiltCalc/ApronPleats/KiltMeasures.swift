import Foundation

public class KiltMeasures: ObservableObject {
  @Published public var actualWaist: Value?
  @Published public var actualHips: Value?

  @Published public var actualHipsDouble: Double?
  @Published public var actualLength: Double?

  init(actualWaist: Double? = nil, actualHips: Double? = nil, actualLength: Double? = nil) {
    self.actualWaist = actualWaist == nil ? nil : Value.inches(actualWaist!)
    self.actualHips = actualHips == nil ? nil : Value.inches(actualHips!)
    self.actualLength = actualLength
  }

  public var idealWaist: Double? {
    actualWaist?.asDouble
  }

  public var idealHips: Double? {
    if !allowsScenarios {
      return nil
    }

    return actualWaist!.asDouble > actualHips!.asDouble
    ? actualWaist!.asDouble
    : actualHips!.asDouble
  }

  public var idealLength: Double? {
    actualLength
  }

  public var allowsScenarios: Bool {
    actualWaist != nil && actualHips != nil
  }
}
