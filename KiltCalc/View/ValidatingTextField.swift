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

  func updateForExternalChange(_ oldValue: Value?, _ newValue: Value?) {
    if isFocused { return }
    if newValue == nil {
      input = ""
      errorMessage = "Value is required"
    } else {
      input = newValue!.formatted(.inches)
      errorMessage = ""
    }
  }

  func updateForInternalChange(_ oldInput: String, _ newInput: String) {
    if !isFocused { return }
    (value, errorMessage) = Self.updateBoundValue(label: label, input: newInput, validator: validator)
  }

  func exitField(_ oldIsFocused: Bool, _ newIsFocused: Bool) {
    if newIsFocused { return }
    if value != nil {
      input = value!.formatted(.inches)
    }
  }

  func enterSlash(_ oldPressed: Bool, _ newPressed: Bool) {
    if !isFocused || !newPressed { return }
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
          .onChange(of: input, updateForInternalChange)
          .onChange(of: value, updateForExternalChange)
          .onChange(of: isFocused, exitField)
          .onChange(of: slashIsPressed, enterSlash)

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
