import Foundation

public class TartanDesign: ObservableObject {
  @Published public var sett: Value?

  @Published public var settsPerPleat: Double = 1.0 {
    didSet {
      if settsPerPleat < 0.5 {
        settsPerPleat = 0.5
      }
    }
  }

  public var pleatFabric: Double? {
    if sett == nil { return nil }
    return sett!.asDouble * settsPerPleat
  }
}
