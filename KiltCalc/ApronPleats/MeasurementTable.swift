import SwiftUI

struct MeasurementTable: View {
  let textfieldWidth = 64.0

  @ObservedObject var measures: KiltMeasures

  @State private var slashIsPressed = false

  @FocusState private var focusedField: PleatViewFocus?

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
        Text("Hips")
          .bold()

        TextField("actualHips", value: $measures.actualHipsDouble, format: .number)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: textfieldWidth)

        Text("\(optionalQuarters(measures.idealHips))")
      }

      Divider()

      GridRow {
        Text("Length")
          .bold()

        TextField("actualLength", value: $measures.actualLength, format: .number)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: textfieldWidth)

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
