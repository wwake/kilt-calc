import SwiftUI

struct MeasurementTable: View {
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
      }
      Divider()
      GridRow {
        Text("Hips")
          .bold()
      }

      Divider()
      GridRow {
        Text("Length")
          .bold()
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
