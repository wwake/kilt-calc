import SwiftUI

struct MeasurementTable: View {
  let textfieldWidth = 64.0

  @Binding var measures: KiltMeasures

  func optionalQuarters(_ value: Double?) -> String {
    if value == nil { return "" }
    return "\(value!.formatQuarter()) in"
  }

  var body: some View {
    Grid {
      GridRow {
        Text("Actual")
          .bold()

        Text("Ideal")
          .bold()
      }

      GridRow {
        ValidatingTextField(
          label: "Waist",
          value: $measures.actualWaist,
          validator: { _ in "" }
        )

        Text("\(optionalQuarters(measures.idealWaist))")
      }

      GridRow {
        ValidatingTextField(
          label: "Hips",
          value: $measures.actualHips,
          validator: { _ in "" }
        )

        Text("\(optionalQuarters(measures.idealHips))")
      }

      GridRow {
        ValidatingTextField(
          label: "Length",
          value: $measures.actualLength,
          validator: { _ in "" }
        )

        Text("\(optionalQuarters(measures.idealLength))")
      }
    }
  }
}

struct MeasurementTable_Previews: PreviewProvider {
  @State static var measures = KiltMeasures()

  static var previews: some View {
    MeasurementTable(measures: Self.$measures)
  }
}
