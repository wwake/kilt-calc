import SwiftUI

struct ApronPleatView: View {
  @Binding var topLevelTab: TopLevelTab
  @ObservedObject var designer: PleatDesigner

  @State var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          Text("Measurements")
            .font(.title2.smallCaps())

          MeasurementTable(measures: $measures)
            .background(.thinMaterial)
            .padding()
            .onChange(of: measures.allowsScenarios) { _ in
              scenarios.changeScenarios(measures.allowsScenarios, measures)
            }
            .onChange(of: measures.idealWaist) { _ in
              scenarios.changeScenarios(measures.allowsScenarios, measures)
            }
            .onChange(of: measures.idealHips) { _ in
              scenarios.changeScenarios(measures.allowsScenarios, measures)
            }

          if measures.allowsScenarios {
            Divider()

            Text("Splits")
              .font(.title2.smallCaps())

            ForEach($scenarios.scenarios) { scenario in
              ScenarioView(scenario: scenario, topLevelTab: $topLevelTab, designer: designer)
                .background(.thinMaterial)
                .padding()
            }
          }
        }
      }
      .background(
        Image(decorative: "Background")
        .resizable()
        .ignoresSafeArea()
      )
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            scenarios.append(measures)
          }) {
            Image(systemName: "plus")
          }
          .opacity(measures.allowsScenarios ? 1.0 : 0.0)
        }
      }
      .navigationTitle("Apron/Pleat Splits")
    }
  }
}

struct ApronPleatView_Previews: PreviewProvider {
  @State static var topLevelTab: TopLevelTab = .apronPleat
  @StateObject static var designer = PleatDesigner(PleatDesigner.boxPleat)

  static var previews: some View {
    ApronPleatView(topLevelTab: Self.$topLevelTab, designer: designer)
  }
}
