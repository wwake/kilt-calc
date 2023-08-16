import Foundation

extension Double {
  func formatFraction() -> String {
    let (whole, part) = modf(self)
    let wholeInt = Int(whole)

    var fractionString = ""

    switch part {
    case 0.25:
      fractionString = "¼"

    case 0.5:
      fractionString = "½"

    case 0.75:
      fractionString = "¾"

    default:
      fractionString = part.formatted()
    }

    if wholeInt == 0 {
      return fractionString
    } else if part == 0 {
      return "\(wholeInt)"
    }
    return "\(wholeInt)\u{2022}\(fractionString)"
  }
}
