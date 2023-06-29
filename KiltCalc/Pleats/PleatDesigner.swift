import Foundation

public class PleatDesigner: ObservableObject {
  @Published public var notes = ""
  @Published public var hipToHipMeasure: Double?
  @Published public var sett: Double?
  @Published public var settsPerPleat = 1.0
  @Published public var pleatWidth: Double?
  @Published public var pleatCount: Double?
  @Published public var gap = 0.0
}
