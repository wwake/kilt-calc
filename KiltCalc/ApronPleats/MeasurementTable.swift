import SwiftUI

private enum MeasurementFocus: Int, CaseIterable, Equatable {
  case waistField,
       hipsField,
       lengthField
}

struct MeasurementTable: View {
  let textfieldWidth = 64.0

  @Binding var measures: KiltMeasures

  @State private var slashIsPressed = false

  @FocusState private var focusedField: MeasurementFocus?

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
      Divider()

      GridRow {
        ValidatingTextField(
          label: "Waist",
          value: $measures.actualWaist,
          validator: { _ in "" },
          slashIsPressed: $slashIsPressed
        )
        .focused($focusedField, equals: .waistField)

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
        .focused($focusedField, equals: .hipsField)

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
        .focused($focusedField, equals: .lengthField)

        Text("\(optionalQuarters(measures.idealLength))")
      }
    }
    .fractionKeyboard(slashIsPressed: $slashIsPressed, focusedField: $focusedField)
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(.black, lineWidth: 2)
    )
  }
}

struct MeasurementTable_Previews: PreviewProvider {
  @State static var measures = KiltMeasures()

  static var previews: some View {
    MeasurementTable(measures: Self.$measures)
  }
}
