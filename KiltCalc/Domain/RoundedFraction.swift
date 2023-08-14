import Foundation

public struct RoundedFraction {
  static let skoshCutoff = 1.0 / 64
  let roundingDenominator = 16

  public var original: Double

  public var signum: Int
  public var wholeNumber: Int
  public var numerator: Int = 0
  public var denominator: Int = 0

  private var originalFraction: Double

  public init(_ aNumber: Double) {
    original = aNumber

    let (wholePart, fractionPart) = modf(aNumber)

    signum = aNumber < 0 ? -1 : 1
    wholeNumber = abs(Int(wholePart))
    originalFraction = abs(fractionPart)

    (numerator, denominator) = self.fractionParts()

    if numerator == denominator {
      wholeNumber += 1
      numerator = 0
    }
  }

  public var skosh: Skosh {
    let rounded = self.asDouble

    if abs(rounded - original) < Self.skoshCutoff {
      return .nothing
    } else if original < rounded {
      return .minus
    } else {
      return .plus
    }
  }

  public var hasFraction: Bool {
    numerator != 0
  }

  private var asDouble: Double {
    Double(signum) * (Double(wholeNumber) + Double(numerator) / Double(denominator))
  }

  fileprivate func fractionParts() -> (Int, Int) {
    var denominator = roundingDenominator
    var numerator = Int(round(originalFraction * Double(denominator)))

    if numerator.isMultiple(of: 2) {
      numerator /= 2
      denominator /= 2
    }

    return (numerator, denominator)
  }
}
