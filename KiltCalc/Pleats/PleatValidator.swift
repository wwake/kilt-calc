extension String {
  fileprivate func and(_ other: String) -> String {
    if !self.isEmpty { return self }
    return other
  }
}

public enum PleatValidator {
  static func gapMessage(_ gap: Double?) -> String {
    if gap == nil {
      return "Type Can't Be Determined"
    }
    if gap!.isZero {
      return "Box Pleat"
    } else if gap! < 0 && gap! > -0.5 {
      return "Box Pleat with Overlap"
    } else if gap! <= -0.5 {
      return "Military Box Pleat"
    } else if gap! > 0 && gap! < 0.5 {
      return "Box Pleat with Gap"
    }
    return "Box Pleat with Too-Large Gap"
  }

  static func requiredPositive(_ value: Value?, _ name: String) -> String {
    required(value, name).and(positive(value, name))
  }

  static func requiredPositive(_ value: Double?, _ name: String) -> String {
    required(value, name).and(positive(value, name))
  }

  static func positiveSmaller(_ value1: Double?, _ name: String, _ value2: Double?) -> String {
    positive(value1, name).and(smaller(value1, name, value2))
  }

  static func required<T>(_ value: T?, _ name: String) -> String {
    value == nil ? "\(name) is required" : ""
  }

  static func positive(_ value: Int?, _ name: String) -> String {
    if value == nil || value! > 0 {
      return ""
    }
    return "\(name) must be positive"
  }

  static func positive(_ value: Double?, _ name: String) -> String {
    if value == nil || value! > 0.0 {
      return ""
    }
    return "\(name) must be positive"
  }

  static func positive(_ value: Value?, _ name: String) -> String {
    if value == nil || value!.asDouble > 0.0 {
      return ""
    }
    return "\(name) must be positive"
  }

  static func smaller(_ value1: Double?, _ name: String, _ value2: Double?) -> String {
    if value1 == nil || value2 == nil || value1! < value2! {
      return ""
    }
    return "\(name) too large"
  }
}
