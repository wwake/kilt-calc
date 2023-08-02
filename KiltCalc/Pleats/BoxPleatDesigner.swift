import Foundation
import SwiftUI

public protocol PleatDesigner: ObservableObject {
  var needsRequiredValues: Bool { get }

  var idealHip: Value? { get set }
  var adjustedHip: Value? { get }
  var hipWasAdjusted: Bool { get }

  var pleatFabric: Double? { get set }
  var pleatCount: Int { get set }
  var pleatWidth: Value? { get set }

  var gap: Double? { get }
  var absoluteGap: Double? { get }
  var gapRatio: Double { get }
  var gapLabel: String { get }

  var totalFabric: Double? { get }
}

public class BoxPleatDesigner: ObservableObject, PleatDesigner {
  private var equations = BoxPleatEquations()

  public var needsRequiredValues: Bool {
    idealHip == nil || pleatFabric == nil
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

  @Published public var pleatFabric: Double? {
    didSet {
      establishNonRequiredVariables()
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
