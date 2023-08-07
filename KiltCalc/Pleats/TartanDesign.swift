import Foundation

public class TartanDesign: ObservableObject {
  @Published public var sett: Value? {
    didSet {
      setPleatFabric()
    }
  }

  @Published public var settsPerPleat: Double = 1.0 {
    didSet {
      if settsPerPleat < 0.5 {
        settsPerPleat = 0.5
      }
      setPleatFabric()
    }
  }

  func setPleatFabric() {
    pleatFabric = sett == nil ? nil : sett!.asDouble * settsPerPleat
  }

  @Published private(set) var pleatFabric: Double?
}
