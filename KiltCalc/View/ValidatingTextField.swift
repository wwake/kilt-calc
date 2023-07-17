import SwiftUI

struct ValidatingTextField: View {
  var label: String
  @Binding var bound: Value?

  @State var input: String = ""
  @State var errorMessage: String = ""

  func updateBoundValue(_ input: String) {
    do {
      let value = try Value.parse(input)
      bound = value
      errorMessage = ""
    } catch {
      bound = nil
      let knownError = error as? String
      errorMessage = knownError != nil ? knownError!.description : "\(error)"
    }
  }

  var body: some View {
    VStack {
      LabeledContent {
        TextField(label, text: $input)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .onChange(of: input, perform: updateBoundValue)
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
