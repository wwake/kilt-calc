import Foundation

public class KiltMeasures: ObservableObject {
  @Published public var actualWaist: Double?
  @Published public var actualHips: Double?
  @Published public var actualLength: Double?

  public var idealWaist: Double? {
    actualWaist
  }

  public var idealHips: Double? {
    if !allowsScenarios {
      return nil
    }

    return actualWaist! > actualHips!
    ? actualWaist
    : actualHips
  }

  public var idealLength: Double? {
    actualLength
  }

  public var allowsScenarios: Bool {
    actualWaist != nil && actualHips != nil
  }
}
