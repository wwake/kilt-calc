import Foundation
import SwiftUI

public class PleatDesigner: ObservableObject {
  public var initialWidth: () -> Double = { 0.0 }

  public var tartan: TartanDesign?

  init(_ pleatInitialWidth: @escaping (PleatDesigner) -> () -> Double) {
    defer {
      self.initialWidth = pleatInitialWidth(self)
    }
  }

  static var boxPleat: (PleatDesigner) -> () -> Double = { designer in {
      designer.pleatFabric! / 3.0
    }
  }

  static var knifePleat: (PleatDesigner) -> () -> Double = { _ in {
      1.0
    }
  }

  var equations = PleatEquations()

  public var needsRequiredValues: Bool {
    idealHip == nil || pleatFabric == nil
  }

  func updateCountAndWidth() {
    withAnimation {
      pleatCount = equations.count
      pleatWidth = .number(equations.width)
    }
  }

  func establishPleatVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      return
    }

    equations.startPleat(
      hip: idealHip!.asDouble,
      fabric: pleatFabric!,
      initialWidth: initialWidth(),
      action: updateCountAndWidth
    )
  }

  @Published public var idealHip: Value? {
    didSet {
      establishPleatVariables()
    }
  }

  public var adjustedHip: Value? {
    if pleatWidth == nil { return nil }
    return .number(Double(pleatCount)) * pleatWidth!
  }

  public var hipWasAdjusted: Bool {
    if idealHip == nil || adjustedHip == nil { return false }
    return idealHip! != adjustedHip!
  }

  public var pleatFabric: Double? {
    // tartan?.pleatFabric
    didSet {
      establishPleatVariables()
    }
  }

  @Published public var pleatCount: Int = 10 {
    didSet {
      if needsRequiredValues {
        return
      }

      equations.setCount(pleatCount, action: updateCountAndWidth)
    }
  }

  @Published public var pleatWidth: Value? {
    didSet {
      if needsRequiredValues || pleatWidth == nil || pleatWidth!.asDouble.isZero {
        return
      }

      equations.setWidth(pleatWidth!.asDouble, action: updateCountAndWidth)
    }
  }

  public var gap: Double? {
    if needsRequiredValues || pleatWidth == nil { return nil }
    return withAnimation {
      (3 * pleatWidth!.asDouble - pleatFabric!) / 2.0
    }
  }

  public var absoluteGap: Double? {
    if gap == nil { return nil }
    return abs(gap!)
  }

  public var gapRatio: Double {
    if gap == nil || pleatWidth == nil { return 0.0 }
    return withAnimation {
      gap! / pleatWidth!.asDouble
    }
  }

  public var gapLabel: String {
    if gap == nil || gap! >= 0 {
      return "Gap"
    }
    return "Overlap"
  }

  public var totalFabric: Double? {
    if needsRequiredValues { return nil }
    return pleatFabric! * Double(pleatCount)
  }
}
