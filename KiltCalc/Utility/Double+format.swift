import Foundation

extension Double {
  fileprivate func roundToQuarter(_ value: Double) -> Double {
    let times4 = value * 4.0
    let roundedValue = Int(times4.rounded())
    return Double(roundedValue) / 4.0
  }

  func formatQuarter() -> String {
    let (whole, part) = modf(roundToQuarter(self))
    let wholeInt = Int(whole)

    var fractionString = ""

    switch part {
    case 0.0:
      fractionString = ""

    case 0.25:
      fractionString = "¼"

    case 0.5:
      fractionString = "½"

    case 0.75:
      fractionString = "¾"

    default:
      fractionString = part.formatted()
    }

    if wholeInt == 0 && part == 0 {
      return "0"
    } else if wholeInt == 0 {
      return fractionString
    } else if part == 0 {
      return "\(wholeInt)"
    }
    return "\(wholeInt)\u{2022}\(fractionString)"
  }
}
