import SwiftUI

struct ValidatingTextField: View {
  var label: String
  @State var input: String = ""
  @State var errorMessage: String = ""
  @Binding var bound: Value?

  func field2() -> some View {
    VStack {
      LabeledContent {
        TextField(label, text: $input)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .onChange(of: input) { input in
            do {
              let value = try Value.parse(input)
              bound = value
              errorMessage = ""
            } catch {
              let knownError = error as? String
              errorMessage = knownError != nil ? knownError!.description : "\(error)"
            }
          }
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

  var body: some View {
    field2()
  }
}
