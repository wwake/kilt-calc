public class KiltMeasures {
  public var actualWaist = 0.0
  public var actualHips = 0.0
  public var actualLength = 0.0

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
