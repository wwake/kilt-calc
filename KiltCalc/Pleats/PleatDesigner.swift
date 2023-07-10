import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  @Published public var notes = ""

  public var message: String {
    PleatValidator.gapMessage(gap)
  }

  public var needsRequiredValues: Bool {
    hipToHipMeasure == nil || sett == nil || settsPerPleat == nil
  }

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      pleatCount = nil
      return
    }

    if !updateInProgress {
      updateInProgress = true
      let tentativePleat = pleatFabric! / 3
      pleatCount = Int(round(hipToHipMeasure! / tentativePleat))
      pleatWidth = hipToHipMeasure! / Double(pleatCount!)
      updateInProgress = false
    }
  }

  @Published public var hipToHipValue: Value? = Value.inches(21.55)

  @Published public var hipToHipMeasure: Double? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var hipError: String {
    PleatValidator.requiredPositive(hipToHipMeasure, "Hip measure")
  }

  @Published public var sett: Double? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var settError: String {
    PleatValidator.requiredPositive(sett, "Sett")
  }

  @Published public var settsPerPleat: Double? = 1.0 {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var settsPerPleatError: String {
    PleatValidator.requiredPositive(settsPerPleat, "Setts/pleat")
  }

  public var pleatFabric: Double? {
    if needsRequiredValues { return nil }
    return sett! * settsPerPleat!
  }

  @Published public var pleatCount: Int? {
    didSet {
      if needsRequiredValues || pleatCount == nil {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        hipToHipMeasure = Double(pleatCount!) * pleatWidth!
        updateInProgress = false
      }
    }
  }

  public var pleatCountError: String {
    PleatValidator.positive(pleatCount, "Pleat count")
  }

  @Published public var pleatWidth: Double? {
    didSet {
      if needsRequiredValues || pleatWidth == nil || pleatCount == nil {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        hipToHipMeasure = Double(pleatCount!) * pleatWidth!
        updateInProgress = false
      }
    }
  }

  public var pleatWidthError: String {
    PleatValidator.positiveSmaller(pleatWidth, "Pleat width", pleatFabric)
  }

  public var gap: Double? {
    if needsRequiredValues || pleatWidth == nil { return nil }
    return (3 * pleatWidth! - pleatFabric!) / 2.0
  }

  public var absoluteGap: Double? {
    if gap == nil { return nil }
    return abs(gap!)
  }

  public var gapLabel: String {
    if gap == nil || gap! >= 0 {
      return "Gap"
    }
    return "Overlap"
  }

  public var totalFabric: Double? {
    if needsRequiredValues || pleatCount == nil { return nil }
    return pleatFabric! * Double(pleatCount!)
  }
}
