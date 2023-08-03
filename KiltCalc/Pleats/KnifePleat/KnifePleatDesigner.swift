import Foundation
import SwiftUI

public class KnifePleatDesigner: PleatDesigner {
  private var equations = PleatEquations()

  public var needsRequiredValues: Bool {
    idealHip == nil || pleatFabric == nil
  }

  fileprivate func updateCountAndWidth() {
    withAnimation {
      pleatCount = equations.count
      pleatWidth = .number(equations.width)
    }
  }

  private func establishNonRequiredVariables() {
    if needsRequiredValues {
      pleatWidth = nil
      return
    }

    equations.startKnifePleat(hip: idealHip!.asDouble, fabric: pleatFabric!, action: updateCountAndWidth)
  }

  public var idealHip: Value? {
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

  public var pleatFabric: Double? {
    didSet {
      establishNonRequiredVariables()
    }
  }

  public var pleatCount: Int = 10 {
    didSet {
      if needsRequiredValues {
        return
      }
      equations.setCount(pleatCount, action: updateCountAndWidth)
    }
  }

  public var pleatWidth: Value? {
    didSet {
      if needsRequiredValues || pleatWidth == nil || pleatWidth!.asDouble.isZero { return }

      equations.setWidth(pleatWidth!.asDouble, action: updateCountAndWidth)
    }
  }

  public var totalFabric: Double? {
    if needsRequiredValues { return nil }

    return pleatFabric! * Double(pleatCount)
  }

  public var gap: Double?

  public var absoluteGap: Double?

  public var gapRatio: Double = 0.0

  public var gapLabel: String = ""
}
