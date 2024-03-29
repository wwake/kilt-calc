import SwiftUI

private struct FractionKeyboard<FOCUS: Hashable>: ViewModifier {
  @Binding var slashIsPressed: Bool
  var focusedField: FocusState<FOCUS?>.Binding

  // see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
  func body(content: Content) -> some View {
    content
      .toolbar {
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
  func fractionKeyboard<FOCUS>(
    slashIsPressed: Binding<Bool>,
    focusedField: FocusState<FOCUS?>.Binding
  ) -> some View {
    modifier(FractionKeyboard(slashIsPressed: slashIsPressed, focusedField: focusedField))
  }
}
