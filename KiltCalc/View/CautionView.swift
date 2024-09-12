import SwiftUI

public struct CautionView: View {
  @Environment(\.dismiss)
  var dismiss

  public var body: some View {
    VStack {
      VStack {
        Image("Logo", bundle: .main)
          .accessibilityLabel(Text("KiltCalc logo"))

        Text("KiltCalc")
          .font(.title)

        Text("Welcome to KiltCalc!")
      }

      VStack(alignment: .leading) {
        Text(verbatim: "This calculator is designed for kiltmakers; it computes measurements in 8ths of inches.")
          .lineLimit(nil)
          .padding([.bottom], 6)

        Text(verbatim: "I know of no calculation defects, but do not rely on just this calculator. " +
             "Before you cut expensive fabric, double-check your calculations by hand or with a calculator you trust.")
        .lineLimit(nil)
        .padding([.bottom], 6)

        Text(verbatim: "There is a known issue with the numeric keyboard - if the 'Done' and '/' buttons disappear, " +
             "please double-click the home button, flick away the open " +
             "version, and click on the app icon again to reactivate it.")
        .lineLimit(nil)
        .padding([.bottom], 6)

        Text(verbatim: "I'd welcome any feedback or suggestions at bill@xp123.com")
          .lineLimit(nil)
          .padding([.bottom], 6)
      }
      .padding(16)

      Button("Got it!") {
        dismiss()
      }
    }
  }
}
