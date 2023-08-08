import SwiftUI

public struct TartanView: View {
  @Binding var tartan: TartanDesign
  @Binding var slashIsPressed: Bool
  var focusedField: FocusState<PleatViewFocus?>.Binding

  public var body: some View {
    VStack {
      ValidatingTextField(
        label: "Sett",
        value: $tartan.sett,
        validator: PleatValidator.positive,
        slashIsPressed: $slashIsPressed
      )
      .focused(focusedField, equals: PleatViewFocus.sett)
      .padding([.trailing], 116)

      TartanDrawing(highlight: tartan.settsPerPleat)

      Slider(value: $tartan.settsPerPleat, in: 0...2, step: 0.25, onEditingChanged: {_ in
        focusedField.wrappedValue = nil
      })
      .padding([.leading, .trailing], 44)

      Text("Setts in One Pleat: \(tartan.settsPerPleat.formatFraction())")
    }
  }
}

struct TartanView_Previews: PreviewProvider {
  @FocusState static private var focusedField: PleatViewFocus?

  static var previews: some View {
    TartanView(tartan: .constant(TartanDesign()), slashIsPressed: .constant(false), focusedField: $focusedField)
  }
}
