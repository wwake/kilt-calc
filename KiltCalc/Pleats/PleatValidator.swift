extension String {
  fileprivate func and(_ other: String) -> String {
    if !self.isEmpty { return self }
    return other
  }
}

public enum PleatValidator {
  static var maximumBoxPleatGap = 0.5
  static var maximumBoxPleatOverlap = 0.5

  static func gapMessage(_ gap: Double?) -> String {
    if gap == nil {
      return "Type Can't Be Determined"
    }

    let gapDouble = gap!
    if gapDouble.isZero {
      return "Box Pleat"
    } else if gapDouble < 0 && gapDouble >= -maximumBoxPleatOverlap {
      return "Box Pleat with Overlap"
    } else if gapDouble <= -maximumBoxPleatOverlap {
      return "Military Box Pleat"
    } else if gapDouble > 0 && gapDouble <= maximumBoxPleatGap {
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
