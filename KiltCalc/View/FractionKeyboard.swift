import SwiftUI

private struct FractionKeyboard<FOCUS: Hashable>: ViewModifier {
  @Binding var slashIsPressed: Bool
  var focusedField: FocusState<FOCUS?>.Binding

  // see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
  // and https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-toolbar-to-the-keyboard

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          HStack {
            Button("Done") {
              focusedField.wrappedValue = nil
            }
            Spacer()
            Button("/") {
              slashIsPressed = true
            }
            .frame(width: 105)
            .background(
              RoundedRectangle(
                cornerRadius: 5,
                style: .continuous
              )
              .fill(.white)
              .stroke(.gray, lineWidth: 1)
            )
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
