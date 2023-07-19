import SwiftUI

struct ValidatingTextField: View {
  var label: String
  @Binding var bound: Value?
  var validator: (Value?) -> String
  var focusTracker: FocusState<PleatViewFocus?>.Binding
  var focusState: PleatViewFocus
  var disabled: Bool

  @State var input: String
  @State var errorMessage: String

  init(
    label: String,
    bound: Binding<Value?>,
    validator: @escaping (Value?) -> String,
    focusTracker: FocusState<PleatViewFocus?>.Binding,
    focusState: PleatViewFocus,
    disabled: Bool = false
  ) {
    self.label = label
    self.validator = validator
    self.disabled = disabled

    self._bound = bound
    if bound.wrappedValue == nil {
      input = ""
      errorMessage = "Value is required"
    } else {
      input = bound.wrappedValue!.formatted(.inches)
      errorMessage = ""
    }

    self.focusTracker = focusTracker
    self.focusState = focusState
  }

  func updateForExternalChange(_ value: Value?) {
    if focusTracker.wrappedValue == focusState { return }

    if value == nil {
      input = ""
      errorMessage = "Value is required"
    } else {
      input = value!.formatted(.inches)
      errorMessage = ""
    }
  }

  func updateForInternalChange(_ input: String) {
    if focusTracker.wrappedValue != focusState { return }
    (bound, errorMessage) = Self.updateBoundValue(label: label, input: input, validator: validator)
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
      LabeledContent {
        TextField(label, text: $input)
          .focused(focusTracker, equals: focusState)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .onChange(of: input, perform: updateForInternalChange)
          .onChange(of: bound, perform: updateForExternalChange)
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
