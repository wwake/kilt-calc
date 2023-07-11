import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  @Published public var notes = ""

  public var message: String {
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
      let tentativePleat = pleatFabric! / .number(3)

      let countAsValue = hipToHipMeasure! / tentativePleat
      pleatCount = .number(round(countAsValue.asDouble))
      pleatWidth = hipToHipMeasure! / pleatCount!
      updateInProgress = false
    }
  }

  @Published public var hipToHipMeasure: Value? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var hipError: String {
    PleatValidator.requiredPositive(hipToHipMeasure, "Hip measure")
  }

  @Published public var sett: Value? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var settError: String {
    PleatValidator.requiredPositive(sett, "Sett")
  }

  @Published public var settsPerPleat: Value? = .number(1.0) {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var settsPerPleatError: String {
    PleatValidator.requiredPositive(settsPerPleat, "Setts/pleat")
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
        hipToHipMeasure = pleatCount! * pleatWidth!
        updateInProgress = false
      }
    }
  }

  public var pleatCountError: String {
    PleatValidator.positive(pleatCount, "Pleat count")
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

  public var pleatWidthError: String {
    PleatValidator.positiveSmaller(pleatWidth, "Pleat width", pleatFabric)
  }

  public var gap: Value? {
    if needsRequiredValues || pleatWidth == nil || pleatWidth!.isError { return nil }
    return (.number(3) * pleatWidth! - pleatFabric!) / .number(2.0)
  }

  public var absoluteGap: Value? {
    if gap == nil { return nil }
    return .inches(abs(gap!.asDouble))
  }

  public var gapLabel: String {
    if gap == nil || gap!.asDouble >= 0 {
      return "Gap"
    }
    return "Overlap"
  }

  public var totalFabric: Value? {
    if needsRequiredValues || pleatCount == nil || pleatCount!.isError { return nil }
    return pleatFabric! * pleatCount!
  }
}
