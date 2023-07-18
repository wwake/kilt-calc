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

  static func positiveSmaller2(_ bigger: Value?) -> ((Value?) -> String) {
    { value in
      let smallerFn = smaller2(value, bigger)
      return positive(value).and(smallerFn(value))
    }
  }

  static func positiveSmaller(_ value1: Value?, _ value2: Value?) -> String {
    positive(value1).and(smaller(value1, value2))
  }

  static func positive(_ value: Value?) -> String {
    if value == nil || value!.asDouble > 0.0 {
      return ""
    }
    return "Must be positive"
  }

  static func smaller2(_ value1: Value?, _ value2: Value?) -> ((Value?) -> String) {
    { value1 in
      if value1 == nil || value2 == nil || value1!.isError || value2!.isError || value1!.asDouble < value2!.asDouble {
        return ""
      }
      return "Value too large"
    }
  }

  static func smaller(_ value1: Value?, _ value2: Value?) -> String {
    if value1 == nil || value2 == nil || value1!.isError || value2!.isError || value1!.asDouble < value2!.asDouble {
      return ""
    }
    return "Value too large"
  }
}
