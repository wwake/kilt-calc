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

  static func positiveSmaller(_ bigger: Double?) -> ((Value?) -> String) {
    { value in
      if bigger == nil { return "" }
      let smallerFn = smaller(value, .inches(bigger!))
      return positive(value).and(smallerFn(value))
    }
  }

  static func positive(_ value: Value?) -> String {
    if value == nil || value!.asDouble > 0.0 {
      return ""
    }
    return "Must be positive"
  }

  static func smaller(_ value1: Value?, _ value2: Value?) -> ((Value?) -> String) {
    { value1 in
      if value1 == nil || value2 == nil || value1!.isError || value2!.isError || value1!.asDouble < value2!.asDouble {
        return ""
      }
      return "Value too large"
    }
  }
}
