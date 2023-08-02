import SwiftUI

public struct PleatCountView: View {
  @ObservedObject var boxPleatDesigner: BoxPleatDesigner
  @Binding private var slashIsPressed: Bool
  private var focusedField: FocusState<PleatViewFocus?>.Binding

  init(
    boxPleatDesigner: BoxPleatDesigner,
    slashIsPressed: Binding<Bool>,
    focusedField: FocusState<PleatViewFocus?>.Binding
  ) {
    self.boxPleatDesigner = boxPleatDesigner
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
          value: $boxPleatDesigner.idealHip,
          validator: PleatValidator.positive,
          slashIsPressed: $slashIsPressed
        )
        .focused(focusedField, equals: .idealHip)

        Spacer()
      }

      HStack {
        Spacer()
        Text("Adjusted Hip Size")
        Text(formatOptional(boxPleatDesigner.adjustedHip))
        Text("in")
        Spacer()
      }
      .adjustedHipStyle(boxPleatDesigner.adjustedHip, boxPleatDesigner.hipWasAdjusted)

      PleatCountDrawing(count: boxPleatDesigner.pleatCount)
        .overlay {
          Stepper(
            "#Pleats:   \(boxPleatDesigner.pleatCount)",
            value: $boxPleatDesigner.pleatCount,
            in: 3...30,
            onEditingChanged: {_ in
              self.focusedField.wrappedValue = nil
            }
          )
          .frame(width: 200)
          .padding([.leading, .trailing], 12)
          .background(Color.white)
          .disabled(boxPleatDesigner.needsRequiredValues)
        }
    }
    .foregroundColor(boxPleatDesigner.needsRequiredValues ? Color.gray : Color.black)
  }
}
