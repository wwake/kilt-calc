extension Double {
  func formatFraction() -> String {
    switch self {
    case 0.25:
      return "¼"

    case 0.5:
      return "½"

    case 0.75:
      return "¾"

    case 1.25:
      return "1\u{2022}¼"

    case 1.5:
      return "1\u{2022}½"

    case 1.75:
      return "1\u{2022}¾"

    default:
      return self.formatted()
    }
  }
}
