import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  public var needsRequiredValues: Bool {
    hipToHipMeasure == nil || sett == nil || settsPerPleat == nil
  }

  @Published public var notes = ""

  @Published public var hipToHipMeasure: Double? {
    didSet {
      if needsRequiredValues {
        pleatFabric = nil
        pleatWidth = nil
        pleatWidth = nil
        pleatCount = nil
        return
      }
    }
  }

  @Published public var sett: Double? {
    didSet {
      if needsRequiredValues {
        pleatFabric = nil
        pleatWidth = nil
        pleatWidth = nil
        pleatCount = nil
        return
      }

      pleatFabric = sett! * settsPerPleat!
      pleatWidth = pleatFabric! / 3
    }
  }

  @Published public var settsPerPleat: Double? = 1.0 {
    didSet {
      if needsRequiredValues {
        pleatFabric = nil
        pleatWidth = nil
        pleatWidth = nil
        pleatCount = nil
        return
      }

      pleatFabric = sett! * settsPerPleat!
      pleatWidth = pleatFabric! / 3
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
