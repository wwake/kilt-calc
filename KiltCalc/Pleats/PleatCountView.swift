import SwiftUI

enum PleatCountFocus: Int, CaseIterable, Equatable {
  case idealHip,
       sett,
       pleatWidth
}

public struct PleatCountView<DESIGNER: PleatDesigner>: View {
  @ObservedObject var designer: DESIGNER
  @Binding private var slashIsPressed: Bool
  private var focusedField: FocusState<PleatCountFocus?>.Binding

  init(
    designer: DESIGNER,
    slashIsPressed: Binding<Bool>,
    focusedField: FocusState<PleatCountFocus?>.Binding
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
      Text("Per Pleat Split")
        .font(.body)

      HStack {
        Spacer()

        ValidatingTextField(
          label: "Hip or Waist",
          value: $designer.idealHip,
          validator: PleatValidator.positive
        )
        .focused(focusedField, equals: .idealHip)

        Spacer()
      }
      .padding([.bottom], 6)

      HStack {
        Spacer()
        Text("Adjusted Size")
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
            in: 3...40,
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
