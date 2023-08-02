import Foundation

public class KnifePleatDesigner: PleatDesigner {
  public var needsRequiredValues: Bool = false

  public var idealHip: Value? = nil

  public var adjustedHip: Value? = nil

  public var hipWasAdjusted: Bool = false

  public var pleatFabric: Double? = nil

  public var pleatCount: Int = 10

  public var pleatWidth: Value? = nil

  public var gap: Double? = nil

  public var absoluteGap: Double? = nil

  public var gapRatio: Double = 1.0

  public var gapLabel: String = ""

  public var totalFabric: Double? = nil
}
