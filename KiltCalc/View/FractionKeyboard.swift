import SwiftUI

struct FractionKeyboard: ViewModifier {
  @Binding var slashIsPressed: Bool
  var focusedField: FocusState<FocusedField?>.Binding

  func body(content: Content) -> some View {
    content
      .toolbar {
        // see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui

        ToolbarItem(placement: .keyboard) {
          HStack {
            Button("Done") {
              focusedField.wrappedValue = nil
            }
            Spacer()
            Button(action: { slashIsPressed = true }) {
              HStack {
                Spacer()
                Text("/")
                  .bold()
                Spacer()
              }
              .padding(2)
              .background(Color.white)
              .frame(width: 100)
            }
          }
        }
      }
  }
}

extension View {
  func fractionKeyboard(
    slashIsPressed: Binding<Bool>,
    focusedField: FocusState<FocusedField?>.Binding
  ) -> some View {
    modifier(FractionKeyboard(slashIsPressed: slashIsPressed, focusedField: focusedField))
  }
}
