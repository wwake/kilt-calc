import SwiftUI

struct MeasurementTable: View {
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

        Text("\(measures.idealWaist)")
      }

      Divider()

      GridRow {
        Text("Hips")
          .bold()

        TextField("actualHips", value: $measures.actualHips, format: .number)

        Text("\(measures.idealHips)")
      }

      Divider()

      GridRow {
        Text("Length")
          .bold()

        TextField("actualLength", value: $measures.actualLength, format: .number)

        Text("\(measures.idealLength)")
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
