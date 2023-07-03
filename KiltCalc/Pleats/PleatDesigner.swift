import Foundation

public class PleatDesigner: ObservableObject {
  private var updateInProgress = false

  @Published public var notes = ""
  @Published public var hipToHipMeasure: Double?

  @Published public var sett: Double? {
    didSet {
      if sett == nil || settsPerPleat == nil {
        pleatFabric = nil
        pleatWidth = nil
        return
      }

      pleatFabric = sett! * settsPerPleat!
      pleatWidth = pleatFabric! / 3
    }
  }

  @Published public var settsPerPleat: Double? = 1.0 {
    didSet {
      if settsPerPleat == nil || sett == nil {
        pleatFabric = nil
        pleatWidth = nil
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
