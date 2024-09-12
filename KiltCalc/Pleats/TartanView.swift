import SwiftUI

public struct TartanView: View {
  @ObservedObject var tartan: TartanDesign

  public var body: some View {
    VStack {
      HStack {
        Spacer()

        ValidatingTextField(
          label: "Sett Size",
          value: $tartan.sett,
          validator: PleatValidator.positive
        )

        Spacer()
      }

      TartanDrawing(highlight: tartan.settsPerPleat)

      Slider(value: $tartan.settsPerPleat, in: 0...2, step: 0.25)
      .padding([.leading, .trailing], 44)

      Text("Setts in One Pleat: \(tartan.settsPerPleat.formatQuarter())")
    }
  }
}

struct TartanView_Previews: PreviewProvider {
  static var previews: some View {
    TartanView(tartan: TartanDesign())
  }
}
