import Foundation
import SwiftUI

public class BoxPleatDesigner: ObservableObject {
  private var equations = BoxPleatEquations()

  public var needsRequiredValues: Bool {
    idealHip == nil || sett == nil
  }

  fileprivate func updateCountAndWidth() {
    withAnimation {
      pleatCount = equations.count
      pleatWidth = .number(equations.width)
    }
  }

  fileprivate func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      return
    }

    equations.setRequired(hip: idealHip!.asDouble, fabric: pleatFabric!, action: updateCountAndWidth)
  }

  @Published public var idealHip: Value? {
    didSet {
      establishNonRequiredVariables()
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

  @Published public var sett: Value? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  @Published public var settsPerPleat: Double = 1.0 {
    didSet {
      if settsPerPleat < 0.5 { settsPerPleat = 0.5 }
      establishNonRequiredVariables()
    }
  }

  public var pleatFabric: Double? {
    if needsRequiredValues { return nil }
    return sett!.asDouble * settsPerPleat
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
      if needsRequiredValues || pleatWidth == nil {
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
