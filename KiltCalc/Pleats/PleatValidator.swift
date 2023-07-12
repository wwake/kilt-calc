extension String {
  fileprivate func and(_ other: String) -> String {
    if !self.isEmpty { return self }
    return other
  }
}

public enum PleatValidator {
  static func gapMessage(_ gap: Value?) -> String {
    if gap == nil {
      return "Type Can't Be Determined"
    }

    let gapDouble = gap!.asDouble
    if gapDouble.isZero {
      return "Box Pleat"
    } else if gapDouble < 0 && gapDouble > -0.5 {
      return "Box Pleat with Overlap"
    } else if gapDouble <= -0.5 {
      return "Military Box Pleat"
    } else if gapDouble > 0 && gapDouble < 0.5 {
      return "Box Pleat with Gap"
    }
    return "Box Pleat with Too-Large Gap"
  }

  static func requiredPositive(_ value: Value?, _ name: String) -> String {
    required(value, name).and(positive(value, name))
  }

  static func positiveSmaller(_ value1: Value?, _ name: String, _ value2: Value?) -> String {
    positive(value1, name).and(smaller(value1, name, value2))
  }

  static func required(_ value: Value?, _ name: String) -> String {
      if value == nil {
          return "\(name) is required"
      }
      if value!.isError {
          var result: String? = nil
          if case let .error(message) = value! {
              result = message
          }
          return result ?? "internal error"
      }
      return ""
  }

  static func positive(_ value: Value?, _ name: String) -> String {
    if value == nil || value!.asDouble > 0.0 {
      return ""
    }
    return "\(name) must be positive"
  }

  static func smaller(_ value1: Value?, _ name: String, _ value2: Value?) -> String {
    if value1 == nil || value2 == nil || value1!.isError || value2!.isError || value1!.asDouble < value2!.asDouble {
      return ""
    }
    return "\(name) too large"
  }
}
