import SwiftUI

struct ValidatingTextField: View {
  var label: String
  @Binding var value: Value?
  var validator: (Value?) -> String
  @Binding var slashIsPressed: Bool
  var disabled: Bool

  @FocusState private var isFocused: Bool

  @State var input: String
  @State var errorMessage: String

  init(
    label: String,
    value: Binding<Value?>,
    validator: @escaping (Value?) -> String,
    slashIsPressed: Binding<Bool>,
    disabled: Bool = false
  ) {
    self.label = label
    self.validator = validator
    self._slashIsPressed = slashIsPressed
    self.disabled = disabled

    self._value = value
    if value.wrappedValue == nil {
      input = ""
      errorMessage = "Value is required"
    } else {
      input = value.wrappedValue!.formatted(.inches)
      errorMessage = ""
    }
  }

  func updateForExternalChange(_ value: Value?) {
    if isFocused { return }
    if value == nil {
      input = ""
      errorMessage = "Value is required"
    } else {
      input = value!.formatted(.inches)
      errorMessage = ""
    }
  }

  func updateForInternalChange(_ input: String) {
    if !isFocused { return }
    (value, errorMessage) = Self.updateBoundValue(label: label, input: input, validator: validator)
  }

  func exitField(_ isFocused: Bool) {
    if isFocused { return }
    if value != nil {
      input = value!.formatted(.inches)
    }
  }

  func enterSlash(_ pressed: Bool) {
    if !isFocused || !pressed { return }
    input.append("/")
    slashIsPressed = false
  }

  static func updateBoundValue(
    label: String,
    input: String,
    validator: @escaping (Value?) -> String
  ) -> (Value?, String) {
    if input.isEmpty {
      return (nil, "Value is required")
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

  var body: some View {
    VStack {
      HStack {
        Text(label)
          .bold()

        TextField(label, text: $input.animation())
          .frame(width: 100)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .focused($isFocused)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .onChange(of: input, perform: updateForInternalChange)
          .onChange(of: value, perform: updateForExternalChange)
          .onChange(of: isFocused, perform: exitField)
          .onChange(of: slashIsPressed, perform: enterSlash)

        Text("in")
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
