import SwiftUI

struct MeasurementTable: View {
  let textfieldWidth = 64.0

  @ObservedObject var measures: KiltMeasures

  @State private var slashIsPressed = false

  @FocusState private var focusedField: FocusedField?

//  @Binding var slashIsPressed: Bool
//  var focusedField: FocusState<PleatViewFocus?>.Binding

  func optionalQuarters(_ value: Double?) -> String {
    if value == nil { return "?" }
    return value!.formatQuarter()
  }

  var body: some View {
    Grid {
      GridRow {
        Text("Actual")
          .bold()

        Text("Ideal")
          .bold()
      }
      Divider()

      GridRow {
        ValidatingTextField(
          label: "Waist",
          value: $measures.actualWaist,
          validator: { _ in "" },
          slashIsPressed: $slashIsPressed
        )

        Text("\(optionalQuarters(measures.idealWaist))")
      }

      Divider()

      GridRow {
        ValidatingTextField(
          label: "Hips",
          value: $measures.actualHips,
          validator: { _ in "" },
          slashIsPressed: $slashIsPressed
        )

        Text("\(optionalQuarters(measures.idealHips))")
      }

      Divider()

      GridRow {
        ValidatingTextField(
          label: "Length",
          value: $measures.actualLength,
          validator: { _ in "" },
          slashIsPressed: $slashIsPressed
        )

        Text("\(optionalQuarters(measures.idealLength))")
      }
    }
    .padding()

    .border(Color.black, width: 2)
  }
}

struct MeasurementTable_Previews: PreviewProvider {
  static var measures = KiltMeasures()

  static var previews: some View {
    MeasurementTable(measures: Self.measures)
  }
}
