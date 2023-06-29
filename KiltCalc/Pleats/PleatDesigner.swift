import Foundation

public class PleatDesigner: ObservableObject {
  @Published public var notes = ""
  @Published public var hipToHipMeasure: Double?

  @Published public var sett: Double? {
    didSet {
      if sett == nil {
        pleatWidth = nil
        return
      }

      pleatWidth = (sett! * settsPerPleat!) / 3
    }
  }

  @Published public var settsPerPleat: Double? = 1.0 {
    didSet {
      if settsPerPleat == nil {
        pleatWidth = nil
        return
      }

      pleatWidth = (sett! * settsPerPleat!) / 3
    }
  }

  @Published public var pleatWidth: Double? {
    didSet {
      if pleatWidth == nil {
        gap = nil
        return
      }
      let fabricForPleat = sett! * settsPerPleat!
      gap = (3 * pleatWidth! - fabricForPleat) / 2.0
    }
  }

  public var pleatCount: Double? {
    if hipToHipMeasure == nil || pleatWidth == nil {
      return nil
    }
    return hipToHipMeasure! / pleatWidth!
  }

  @Published public var gap: Double?
}
