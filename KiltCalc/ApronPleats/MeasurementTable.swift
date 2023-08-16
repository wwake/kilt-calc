import SwiftUI

struct MeasurementTable: View {
  let textfieldWidth = 50.0

  @StateObject var measures = KiltMeasures()

  var body: some View {
    Grid {
      GridRow {
        Text("")

        Text("Actual")
          .bold()

        Text("Ideal")
          .bold()
      }
      Divider()

      GridRow {
        Text("Waist")
          .bold()

        TextField("actualWaist", value: $measures.actualWaist, format: .number)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: textfieldWidth)

        Text("\(measures.idealWaist.formatFraction())")
      }

      Divider()

      GridRow {
        Text("Hips")
          .bold()

        TextField("actualHips", value: $measures.actualHips, format: .number)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: textfieldWidth)

        Text("\(measures.idealHips.formatFraction())")
      }

      Divider()

      GridRow {
        Text("Length")
          .bold()

        TextField("actualLength", value: $measures.actualLength, format: .number)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: textfieldWidth)

        Text("\(measures.idealLength.formatFraction())")
      }
    }
    .padding()

    .border(Color.black, width: 2)
  }
}

struct MeasurementTable_Previews: PreviewProvider {
  static var previews: some View {
    MeasurementTable()
  }
}
