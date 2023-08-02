import SwiftUI

public struct PleatCountView: View {
  @ObservedObject var designer: BoxPleatDesigner
  @Binding private var slashIsPressed: Bool
  private var focusedField: FocusState<PleatViewFocus?>.Binding

  init(
    designer: BoxPleatDesigner,
    slashIsPressed: Binding<Bool>,
    focusedField: FocusState<PleatViewFocus?>.Binding
  ) {
    self.designer = designer
    self._slashIsPressed = slashIsPressed
    self.focusedField = focusedField
  }

  func formatOptional(_ value: Value?) -> String {
    if value == nil {
      return "?"
    }
    return "\(value!.formatted(.inches))"
  }

  public var body: some View {
    VStack {
      HStack {
        Spacer()

        ValidatingTextField(
          label: "Ideal Hip",
          value: $designer.idealHip,
          validator: PleatValidator.positive,
          slashIsPressed: $slashIsPressed
        )
        .focused(focusedField, equals: .idealHip)

        Spacer()
      }

      HStack {
        Spacer()
        Text("Adjusted Hip Size")
        Text(formatOptional(designer.adjustedHip))
        Text("in")
        Spacer()
      }
      .adjustedHipStyle(designer.adjustedHip, designer.hipWasAdjusted)

      PleatCountDrawing(count: designer.pleatCount)
        .overlay {
          Stepper(
            "#Pleats:   \(designer.pleatCount)",
            value: $designer.pleatCount,
            in: 3...30,
            onEditingChanged: {_ in
              self.focusedField.wrappedValue = nil
            }
          )
          .frame(width: 200)
          .padding([.leading, .trailing], 12)
          .background(Color.white)
          .disabled(designer.needsRequiredValues)
        }
    }
    .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
  }
}
