import SwiftUI

public struct Gap {
  public var pleatWidth: Value?
  public var pleatFabric: Double?

  private var needsRequiredValues: Bool {
    pleatWidth == nil || pleatFabric == nil
  }

  public var size: Double {
    if needsRequiredValues { return 0.0 }

    return withAnimation {
      (3 * pleatWidth!.asDouble - pleatFabric!) / 2.0
    }
  }

  public var shouldDraw: Bool {
    !PleatValidator.isMilitaryBoxPleat(size)
  }

  public var label: String {
    let name = size >= 0 ? "Gap" : "Overlap"
    return "\(name): \(formatOptional(abs(size)))"
  }

  public var ratio: Double {
    if pleatWidth == nil { return 0.0 }
    return withAnimation {
      size / pleatWidth!.asDouble
    }
  }

  private func formatOptional(_ value: Double?) -> String {
    if value == nil {
      return "?"
    }
    return Value.inches(value!).formatted(.inches)
  }
}

extension Gap: Equatable {}
