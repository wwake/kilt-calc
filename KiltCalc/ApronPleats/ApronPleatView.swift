import SwiftUI

struct ApronPleatView: View {
  @Binding var topLevelTab: TopLevelTab
  @ObservedObject var designer: PleatDesigner

  @State var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  var body: some View {
    NavigationStack {
      List {
        Section("Measurements") {
          MeasurementTable(measures: $measures)
            .padding([.top, .bottom], 6)
            .onChange(of: measures.allowsScenarios) {
              scenarios.changeScenarios(measures.allowsScenarios, measures)
            }
            .onChange(of: measures.idealWaist) {
              scenarios.changeScenarios(measures.allowsScenarios, measures)
            }
            .onChange(of: measures.idealHips) {
              scenarios.changeScenarios(measures.allowsScenarios, measures)
            }
        }

        if measures.allowsScenarios {
          Section("Splits") {
            ForEach($scenarios.scenarios) { scenario in
              ScenarioView(scenario: scenario, topLevelTab: $topLevelTab, designer: designer)
            }
          }
        }
      }
      .scrollContentBackground(.hidden)
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
              .accessibilityLabel("Add Scenario")
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
