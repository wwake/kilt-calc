import SwiftUI

public struct TartanView: View {
  @ObservedObject var tartan: TartanDesign
  var focusedField: FocusState<PleatCountFocus?>.Binding

  public var body: some View {
    VStack {
      HStack {
        Spacer()

        ValidatingTextField(
          label: "Sett Size",
          value: $tartan.sett,
          validator: PleatValidator.positive
        )
        .focused(focusedField, equals: PleatCountFocus.sett)

        Spacer()
      }

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
  @FocusState private static var focusedField: PleatCountFocus?

  static var previews: some View {
    TartanView(tartan: TartanDesign(), focusedField: $focusedField)
  }
}
