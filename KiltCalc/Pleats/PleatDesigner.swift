import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false
  private var equations = PleatEquations()

  public var pleatType: String {
    PleatValidator.gapMessage(gap)
  }

  public var needsRequiredValues: Bool {
    idealHip == nil || sett == nil || settsPerPleat == nil
    || idealHip!.isError || sett!.isError || settsPerPleat!.isError
  }

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      pleatCount = nil
      return
    }

    if !updateInProgress {
      updateInProgress = true
      equations.setRequired(hip: idealHip!.asDouble, fabric: pleatFabric!.asDouble)
      pleatCount = .number(equations.count)
      pleatWidth = .inches(equations.width)
      updateInProgress = false
    }
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

  public var pleatFabric: Value? {
    if needsRequiredValues { return nil }
    return sett! * settsPerPleat!
  }

  @Published public var pleatCount: Value? {
    didSet {
      if needsRequiredValues || pleatCount == nil || pleatCount!.isError {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        pleatCount = pleatCount!.round()

        let possiblePleatWidth = idealHip! / pleatCount!
        if possiblePleatWidth.asDouble <= pleatFabric!.asDouble {
          pleatWidth = possiblePleatWidth
        } else {
          pleatWidth = pleatFabric!
        }

        updateInProgress = false
      }
    }
  }

  @Published public var pleatWidth: Value? {
    didSet {
      if needsRequiredValues || pleatWidth == nil || pleatCount == nil || pleatWidth!.isError || pleatCount!.isError {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        pleatCount = (idealHip! / pleatWidth!).round()
        updateInProgress = false
      }
    }
  }

  public var gap: Value? {
    if needsRequiredValues || pleatWidth == nil || pleatWidth!.isError { return nil }
    return (.number(3) * pleatWidth! - pleatFabric!) / .number(2.0)
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

  public var totalFabric: Value? {
    if needsRequiredValues || pleatCount == nil || pleatCount!.isError { return nil }
    return pleatFabric! * pleatCount!
  }
}
