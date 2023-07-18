import SwiftUI

struct ValidatingTextField: View {
  var label: String
  @Binding var bound: Value?
  var validator: (Value?) -> String
  var disabled: Bool

  @State var input: String
  @State var errorMessage: String

  init(label: String, bound: Binding<Value?>, validator: @escaping (Value?) -> String, disabled: Bool = false) {
    self.label = label
    self.validator = validator
    self.disabled = disabled

    self._bound = bound
    if bound.wrappedValue == nil {
      input = ""
      errorMessage = "\(label) is missing"
    } else {
      input = bound.wrappedValue!.formatted(.inches)
      errorMessage = ""
    }
  }

  static func updateBoundValue(
    label: String,
    input: String,
    validator: @escaping (Value?) -> String
  ) -> (Value?, String) {
    if input.isEmpty {
      return (nil, "\(label) is missing")
    }
    do {
      let value = try Value.parse(input)
      return (value, validator(value))
    } catch {
      let knownError = error as? String
      let message = knownError != nil ? knownError!.description : "\(error)"
      return (nil, message)
    }
  }

  func updateBoundAndError(_ input: String) {
    (bound, errorMessage) = Self.updateBoundValue(label: label, input: input, validator: validator)
  }

  var body: some View {
    VStack {
      LabeledContent {
        TextField(label, text: $input)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .onChange(of: input, perform: updateBoundAndError)
      } label: {
        Text(label)
          .bold()
      }
      .padding(disabled || errorMessage.isEmpty ? 0 : 8)
      .border(Color.red, width: disabled || errorMessage.isEmpty ? 0 : 1)

      if !disabled && !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.footnote)
          .foregroundColor(Color.red)
      }
    }
    .foregroundColor(disabled ? Color.gray : Color.black)
    .disabled(disabled)
  }
}
