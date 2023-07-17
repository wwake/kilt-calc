import SwiftUI

struct ValidatingTextField: View {
  var label: String
  @Binding var bound: Value?

  @State var input: String = ""
  @State var errorMessage: String = ""

  static func updateBoundValue(_ input: String) -> (Value?, String) {
    do {
      let value = try Value.parse(input)
      return (value, "")
    } catch {
      let knownError = error as? String
      let message = knownError != nil ? knownError!.description : "\(error)"
      return (nil, message)
    }
  }

  func updateBoundAndError(_ input: String) {
    (bound, errorMessage) = Self.updateBoundValue(input)
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
      .padding(errorMessage.isEmpty ? 0 : 8)
      .border(Color.red, width: errorMessage.isEmpty ? 0 : 1)

      if !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.footnote)
          .foregroundColor(Color.red)
      }
    }
  }
}
