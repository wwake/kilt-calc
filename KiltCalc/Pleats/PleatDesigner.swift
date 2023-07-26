import Foundation

public class PleatDesigner: ObservableObject {
  private var equations = PleatEquations()

  public var pleatType: String {
    PleatValidator.gapMessage(gap)
  }

  public var needsRequiredValues: Bool {
    idealHip == nil || sett == nil || settsPerPleat == nil
    || idealHip!.isError || sett!.isError || settsPerPleat!.isError
  }

  fileprivate func updateCountAndWidth() {
    pleatCount = .number(equations.count)
    pleatWidth = .inches(equations.width)
  }

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      pleatCount = nil
      return
    }

    equations.setRequired(hip: idealHip!.asDouble, fabric: pleatFabric!, action: updateCountAndWidth)
  }

  @Published public var idealHip: Value? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var adjustedHip: Value? {
    if pleatCount == nil || pleatWidth == nil { return nil }
    return pleatCount! * pleatWidth!
  }

  public var hipWasAdjusted: Bool {
    if idealHip == nil || adjustedHip == nil { return false }
    return idealHip! != adjustedHip!
  }

  @Published public var sett: Value? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  @Published public var settsPerPleat: Value? = .number(1.0) {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var pleatFabric: Double? {
    if needsRequiredValues { return nil }
    return sett!.asDouble * settsPerPleat!.asDouble
  }

  @Published public var pleatCount: Value? {
    didSet {
      if needsRequiredValues || pleatCount == nil || pleatCount!.isError {
        return
      }

      equations.setCount(pleatCount!.asDouble, action: updateCountAndWidth)
    }
  }

  @Published public var pleatWidth: Value? {
    didSet {
      if needsRequiredValues || pleatWidth == nil || pleatCount == nil || pleatWidth!.isError || pleatCount!.isError {
        return
      }

      equations.setWidth(pleatWidth!.asDouble, action: updateCountAndWidth)
    }
  }

  public var gap: Value? {
    if needsRequiredValues || pleatWidth == nil || pleatWidth!.isError { return nil }
    return (.number(3) * pleatWidth! - .inches(pleatFabric!)) / .number(2.0)
  }

  public var absoluteGap: Value? {
    if gap == nil || gap!.isError { return nil }
    return gap!.abs()
  }

  public var gapRatio: Double {
    if gap == nil || pleatWidth == nil { return 0.0 }
    return gap!.asDouble / pleatWidth!.asDouble
  }

  public var gapLabel: String {
    if gap == nil || gap!.isError || gap!.isNonNegative() {
      return "Gap"
    }
    return "Overlap"
  }

  public var totalFabric: Double? {
    if needsRequiredValues || pleatCount == nil || pleatCount!.isError { return nil }
    return pleatFabric! * pleatCount!.asDouble
  }
}
