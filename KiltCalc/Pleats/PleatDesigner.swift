import Foundation

public class PleatDesigner: ObservableObject {
  @Published public var notes = ""
  @Published public var hipToHipMeasure: Double?
  @Published public var sett: Double?
  @Published public var settsPerPleat: Double? = 1.0
  @Published public var pleatWidth: Double?

  public var pleatCount: Double? {
    if hipToHipMeasure == nil || pleatWidth == nil {
      return nil
    }
    return hipToHipMeasure! / pleatWidth!
  }

  @Published public var gap: Double? = 0.0
}
