import SwiftUI

struct ScenarioView: View {
  @Binding var scenario: ScenarioSplit
  @State private var waistSplit: Double = 0
  @State private var hipsSplit: Double = 0

  var body: some View {
    VStack {
      Grid {
        GridRow {
          Text("")

          Text("Apron")
            .bold()

          Text("Pleats")
            .bold()
        }
        Divider()

        GridRow {
          Text("")
          Slider(value: $waistSplit, in: -2...2, step: 0.25)
            .gridCellColumns(2)
            .onChange(of: waistSplit) {
              scenario[.waist]?.givePleat($0)
            }
        }

        GridRow {
          Text("Waist")
            .bold()

          Text("\(scenario[.waist]!.apron.formatQuarter())")

          Text("\(scenario[.waist]!.pleat.formatQuarter())")
        }

        Divider()

        GridRow {
          Text("Hips")
            .bold()

          Text("\(scenario[.hips]!.apron.formatQuarter())")

          Text("\(scenario[.hips]!.pleat.formatQuarter())")
        }

        GridRow {
          Text("")
          Slider(value: $hipsSplit, in: -2...2, step: 0.25)
            .gridCellColumns(2)
            .onChange(of: hipsSplit) {
              scenario[.hips]?.givePleat($0)
            }
        }
      }
      .padding()
      .border(Color.black, width: 2)

      ForEach(scenario.warnings, id: \.self) {
        Text($0)
          .foregroundColor(.red)
      }
      .padding()
      .border(.red, width: 2)
    }
  }
}

struct ScenarioView_Previews: PreviewProvider {
  @State static var split = ScenarioSplit([.waist: 22.0, .hips: 30.0])

  static var previews: some View {
    ScenarioView(scenario: $split)
  }
}
