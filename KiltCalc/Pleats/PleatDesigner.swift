import Combine
import Foundation
import SwiftUI

public struct Gap {
  public var pleatWidth: Value?
  public var pleatFabric: Double?

  private var needsRequiredValues: Bool {
    pleatWidth == nil || pleatFabric == nil
  }

  public var size: Double? {
    if needsRequiredValues { return nil }
    return withAnimation {
      (3 * pleatWidth!.asDouble - pleatFabric!) / 2.0
    }
  }

  public var absoluteSize: Double? {
    if size == nil { return nil }
    return abs(size!)
  }

  public var shouldDraw: Bool {
    !PleatValidator.isMilitaryBoxPleat(size)
  }

  public var label: String {
    if size == nil || size! >= 0 {
      return "Gap"
    }
    return "Overlap"
  }
}

public class PleatDesigner: ObservableObject {
  public var initialWidth: () -> Double = { 0.0 }
  private(set) var gap: Gap?

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
    idealHip == nil || idealHip!.asDouble < 1 || pleatFabric == nil
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
      gap = nil
      return
    }

    equations.startPleat(
      hip: idealHip!.asDouble,
      fabric: pleatFabric!,
      initialWidth: initialWidth(),
      action: updateCountAndWidth
    )

    setGap()
  }

  private func setGap() {
    gap = Gap(
      pleatWidth: pleatWidth,
      pleatFabric: pleatFabric
    )
  }

  @Published public var idealHip: Value? {
    didSet {
      establishPleatVariables()
    }
  }

  public var pleatFabric: Double? {
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

  @Published public var pleatCount: Int = 10 {
    didSet {
      if needsRequiredValues {
        gap = nil
        return
      }

      equations.setCount(pleatCount, action: updateCountAndWidth)
      setGap()
    }
  }

  @Published public var pleatWidth: Value? {
    didSet {
      if needsRequiredValues || pleatWidth == nil || pleatWidth!.asDouble.isZero {
        gap = nil
        return
      }

      equations.setWidth(pleatWidth!.asDouble, action: updateCountAndWidth)
      setGap()
    }
  }

  public var gapSize: Double? {
    gap?.size
  }

  public var absoluteGap: Double? {
    gap?.absoluteSize
  }

  public var gapRatio: Double {
    if gapSize == nil || pleatWidth == nil { return 0.0 }
    return withAnimation {
      gapSize! / pleatWidth!.asDouble
    }
  }

  public var gapLabel: String {
    gap?.label ?? "Gap"
  }

  public var depth: Double? {
    if pleatFabric == nil || pleatWidth == nil { return nil }
    return (pleatFabric! - pleatWidth!.asDouble) / 2
  }

  public var totalFabric: Double? {
    if needsRequiredValues { return nil }
    return pleatFabric! * Double(pleatCount)
  }
}
