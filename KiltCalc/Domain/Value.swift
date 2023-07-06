import Foundation

public enum Value {
  case error(String)
  case number(Double)
  case inches(Double)

  static let parseStrategy = ValueParseStrategy()
  static let valueFormatter = ValueFormatter()
  public static var imperialFormatter = ImperialFormatter.inches
}

extension Value {
  static func + (lhs: Value, rhs: Value) -> Value {
    lhs.plus(rhs)
  }

  static func - (lhs: Value, rhs: Value) -> Value {
    lhs.minus(rhs)
  }

  static func * (lhs: Value, rhs: Value) -> Value {
    lhs.times(rhs)
  }

  static func / (lhs: Value, rhs: Value) -> Value {
    lhs.divide(rhs)
  }
}

extension Value: Equatable {
  public func negate() -> Value {
    switch self {
    case .error:
      return self

    case .number(let value):
      return .number(-value)

    case .inches(let value):
      return .inches(-value)
    }
  }

  public func minus(_ other: Value) -> Value {
    plus(other.negate())
  }

  public func plus(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
      return other

    case let (.number(a), .number(b)):
      return .number(a + b)

    case let (.number(a), .inches(b)):
      if b == 0 {
        return self
      } else if a == 0 {
        return other
      }
      return .error("error - mixing inches and numbers")

    case let (.inches(a), .number(b)):
      if a == 0 {
        return other
      } else if b == 0 {
        return self
      }
      return .error("error - mixing inches and numbers")

    case let (.inches(a), .inches(b)):
      if (a + b).isZero {
        return .number(0)
      }
      return .inches(a + b)
    }
  }

  public func times(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
      return other

    case let (.number(a), .number(b)):
      return .number(a * b)

    case let (.number(a), .inches(b)):
      if a.isZero || b.isZero {
        return .number(0)
      }
      return .inches(a * b)

    case let (.inches(a), .number(b)):
      if a.isZero || b.isZero {
        return .number(0)
      }
      return .inches(a * b)

    case let (.inches(a), .inches(b)):
      if a.isZero || b.isZero {
        return .number(0)
      }
      return .error("error - can't handle square inches")
    }
  }

  public func divide(_ other: Value) -> Value {
    switch (self, other) {
    case (.error, _):
      return self

    case (_, .error):
      return other

    case let (.number(a), .number(b)):
      return .number(a / b)

    case let (.number(a), .inches):
      if a.isZero {
        return .number(0)
      }
      return .error("error - can't divide number by inches")

    case let (.inches(a), .number(b)):
      if a.isZero {
        return .number(0)
      }
      return .inches(a / b)

    case let (.inches(a), .inches(b)):
      return .number(a / b)
    }
  }
}

extension Value {
  static func parse(_ input: String) -> Value {
    do {
      return try parseStrategy.parse(input)
    } catch ValueParseError.error(let errorString) {
      return .error(errorString)
    } catch {
      return .error("internal error")
    }
  }
}

extension Value {
  public struct ValueFormatStyle: ParseableFormatStyle {
    enum ValueFormatType: Codable {
      case inches
      case yardFeetInches
    }

    var type: ValueFormatType

    init(_ type: ValueFormatType) {
      self.type = type
    }

    public var parseStrategy: ValueParseStrategy {
      ValueParseStrategy()
    }

    public func format(_ value: Value) -> String {
      valueFormatter.format(Value.imperialFormatter.formatter, value)
    }
  }
}

extension Value.ValueFormatStyle: Codable {
  enum CodingKeys: String, CodingKey {
    case type
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let newType = try? container.decodeIfPresent(ValueFormatType.self, forKey: .type) {
      type = newType
    } else {
      type = .inches
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(type, forKey: .type)
  }
}

extension Value.ValueFormatStyle: Hashable {}

extension Value {
   public func formatted(_ formatStyle: ValueFormatStyle) -> String {
    formatStyle.format(self)
  }
}

extension FormatStyle where Self == Value.ValueFormatStyle {
  public static var inches: Value.ValueFormatStyle {
    Value.ValueFormatStyle(.inches)
  }

  public static var yardFeetInches: Value.ValueFormatStyle {
    Value.ValueFormatStyle(.yardFeetInches)
  }
}
