import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  public var needsRequiredValues: Bool {
    hipToHipMeasure == nil || sett == nil || settsPerPleat == nil
  }

  @Published public var notes = ""

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatFabric = nil
      pleatWidth = nil
      pleatWidth = nil
      pleatCount = nil
      return
    }

    updateInProgress = true
    pleatFabric = sett! * settsPerPleat!
    pleatWidth = pleatFabric! / 3
    gap = 0
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

  @Published public var pleatFabric: Double?

  @Published public var pleatWidth: Double? {
    didSet {
      if pleatWidth == nil || pleatFabric == nil {
        gap = nil
        return
      }

      gap = (3 * pleatWidth! - pleatFabric!) / 2.0

      if !updateInProgress {
        updateInProgress = true
        pleatCount = hipToHipMeasure == nil ? nil : hipToHipMeasure! / pleatWidth!
        updateInProgress = false
      }
    }
  }

  @Published public var pleatCount: Double? {
    didSet {
      if pleatCount == nil || hipToHipMeasure == nil {
        return
      }

      if !updateInProgress {
        updateInProgress = true
        pleatWidth = hipToHipMeasure! / pleatCount!
        updateInProgress = false
      }
    }
  }

  @Published public var gap: Double?
}
