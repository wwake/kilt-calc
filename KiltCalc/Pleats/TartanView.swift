import SwiftUI

public struct TartanView: View {
  @ObservedObject var tartan: TartanDesign
  @Binding var slashIsPressed: Bool
  var focusedField: FocusState<FocusedField?>.Binding

  public var body: some View {
    VStack {
      ValidatingTextField(
        label: "Sett",
        value: $tartan.sett,
        validator: PleatValidator.positive,
        slashIsPressed: $slashIsPressed
      )
      .focused(focusedField, equals: FocusedField.sett)
      .padding([.trailing], 116)

      TartanDrawing(highlight: tartan.settsPerPleat)

      Slider(value: $tartan.settsPerPleat, in: 0...2, step: 0.25, onEditingChanged: {_ in
        focusedField.wrappedValue = nil
      })
      .padding([.leading, .trailing], 44)

      Text("Setts in One Pleat: \(tartan.settsPerPleat.formatQuarter())")
    }
  }
}

struct TartanView_Previews: PreviewProvider {
  @FocusState private static var focusedField: FocusedField?

  static var previews: some View {
    TartanView(tartan: TartanDesign(), slashIsPressed: .constant(false), focusedField: $focusedField)
  }
}
