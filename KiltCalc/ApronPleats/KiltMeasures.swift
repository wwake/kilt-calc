import Foundation

public class KiltMeasures: ObservableObject {
  @Published public var actualWaist = 0.0
  @Published public var actualHips = 0.0
  @Published public var actualLength = 0.0

  public var idealWaist: Double {
    actualWaist
  }

  public var idealHips: Double {
    actualWaist > actualHips
    ? actualWaist
    : actualHips
  }

  public var idealLength: Double {
    actualLength
  }
}
