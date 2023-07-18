import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  @Published public var notes = ""

  public var pleatType: String {
    PleatValidator.gapMessage(gap)
  }

  public var needsRequiredValues: Bool {
    hipToHipMeasure == nil || sett == nil || settsPerPleat == nil
    || hipToHipMeasure!.isError || sett!.isError || settsPerPleat!.isError
  }

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      pleatCount = nil
      return
    }

    if !updateInProgress {
      updateInProgress = true
      let tentativePleatWidth = pleatFabric! / .number(3)
      let countAsValue = hipToHipMeasure! / tentativePleatWidth
      pleatCount = countAsValue.round()
      pleatWidth = hipToHipMeasure! / pleatCount!
      updateInProgress = false
    }
  }

  @Published public var hipToHipMeasure: Value? {
    didSet {
      establishNonRequiredVariables()
    }
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

        if pleatWidth != nil {
          hipToHipMeasure = pleatCount! * pleatWidth!
        } else {
          pleatWidth = hipToHipMeasure! / pleatCount!
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
        hipToHipMeasure = pleatCount! * pleatWidth!
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
