import Foundation

public class KnifePleatDesigner: PleatDesigner {
  public var needsRequiredValues: Bool = true

  public var idealHip: Value? = nil

  public var adjustedHip: Value? = nil

  public var hipWasAdjusted: Bool = false

  public var pleatFabric: Double? = nil

  public var pleatCount: Int = 10

  public var pleatWidth: Value? {
    didSet {
      if idealHip == nil || pleatWidth == nil || pleatWidth!.asDouble.isZero { return }

      pleatCount = Int(round(idealHip!.asDouble / pleatWidth!.asDouble))
    }
  }

  public var totalFabric: Double? = nil

  public var gap: Double?

  public var absoluteGap: Double?

  public var gapRatio: Double = 0.0

  public var gapLabel: String = ""
}
