import Foundation

public class KnifePleatDesigner: PleatDesigner {
  public var needsRequiredValues: Bool {
    idealHip == nil || pleatFabric == nil
  }

  private func establishNonRequiredVariables() {
    if needsRequiredValues {
      return
    }

    pleatWidth = .inches(1)
    pleatCount = Int(round(idealHip!.asDouble))
  }

  public var idealHip: Value? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var adjustedHip: Value? = nil

  public var hipWasAdjusted: Bool = false

  public var pleatFabric: Double? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var pleatCount: Int = 10

  public var pleatWidth: Value? {
    didSet {
      if idealHip == nil || pleatWidth == nil || pleatWidth!.asDouble.isZero { return }

      pleatCount = Int(round(idealHip!.asDouble / pleatWidth!.asDouble))
    }
  }

  public var totalFabric: Double? {
    if pleatFabric == nil { return nil }

    return pleatFabric! * Double(pleatCount)
  }

  public var gap: Double?

  public var absoluteGap: Double?

  public var gapRatio: Double = 0.0

  public var gapLabel: String = ""
}
