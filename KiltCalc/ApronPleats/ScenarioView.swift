import SwiftUI

struct ScenarioView: View {
  @Binding var scenario: ScenarioSplit
  @Binding var topLevelTab: TopLevelTab
  @ObservedObject var designer: PleatDesigner

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
            .onChange(of: waistSplit) { _, split in
              scenario[.waist]?.giveApron(split)
            }
        }

        GridRow {
          Text("Waist")
            .bold()

          Text("\(scenario[.waist]!.apron.formatQuarter())")

          Text("\(scenario[.waist]!.pleat.formatQuarter())")
        }

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
            .onChange(of: hipsSplit) { _, split in
              scenario[.hips]?.giveApron(split)
            }
        }

        if scenario.hasWarnings {
          Divider()

          VStack(alignment: .leading) {
            ForEach(scenario.warnings, id: \.self) {
              Text($0)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .foregroundColor(.red)
            }
          }
        }

        HStack {
          Spacer()
          Button("→ Pleats") {
            designer.idealHip = Value.number(scenario[.hips]!.pleat)
            topLevelTab = .pleats
          }
        }
      }
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(scenario.hasWarnings ? .red : .clear, lineWidth: 2)
      )
    }
  }
}

struct ScenarioView_Previews: PreviewProvider {
  @State static var split = ScenarioSplit([.waist: 22.0, .hips: 30.0])
  @State static var topLevelTab = TopLevelTab.apronPleat
  @StateObject static var designer = PleatDesigner(PleatDesigner.boxPleat)

  static var previews: some View {
    ScenarioView(scenario: $split, topLevelTab: $topLevelTab, designer: designer)
  }
}
