import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  @Published public var notes = ""

  public var needsRequiredValues: Bool {
    hipToHipMeasure == nil || sett == nil || settsPerPleat == nil
  }

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      pleatCount = nil
      return
    }

    updateInProgress = true
    pleatWidth = pleatFabric! / 3
    pleatCount = hipToHipMeasure! / pleatWidth!
    updateInProgress = false
  }

  @Published public var hipToHipMeasure: Double? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  @Published public var sett: Double? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  @Published public var settsPerPleat: Double? = 1.0 {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var pleatFabric: Double? {
    if needsRequiredValues { return nil }
    return sett! * settsPerPleat!
  }

  @Published public var pleatCount: Double? {
    didSet {
      if needsRequiredValues {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        pleatWidth = hipToHipMeasure! / pleatCount!
        updateInProgress = false
      }
    }
  }

  @Published public var pleatWidth: Double? {
    didSet {
      if needsRequiredValues {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        pleatCount = hipToHipMeasure == nil ? nil : hipToHipMeasure! / pleatWidth!
        updateInProgress = false
      }
    }
  }

  public var gap: Double? {
    if needsRequiredValues { return nil }
    return (3 * pleatWidth! - pleatFabric!) / 2.0
  }
}
